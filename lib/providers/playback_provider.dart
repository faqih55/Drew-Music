import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/track.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';
import '../services/youtube_music_service.dart';

class PlaybackProvider extends ChangeNotifier {
  final AudioService _audioService;
  final StorageService _storageService;
  final YoutubeMusicService _musicService;

  Track? _currentTrack;
  List<Track> _queue = [];
  int _currentIndex = -1;

  bool _isPlaying = false;
  bool _isBuffering = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _volume = 1.0;
  LoopMode _loopMode = LoopMode.off;
  bool _shuffleEnabled = false;
  int _playRequestCounter = 0;

  List<Track> _favorites = [];
  List<Track> _recentlyPlayed = [];
  String _playbackError = '';
  String? _currentCanvasVideoUrl;

  // Performance optimization: debounce position updates
  DateTime? _lastPositionUpdate;
  static const _positionUpdateThrottle = Duration(milliseconds: 50);

  PlaybackProvider({
    required this._audioService,
    required this._storageService,
    required this._musicService,
  }) {
    _initStreams();
    _loadLibrary();
  }

  // Getters
  Track? get currentTrack => _currentTrack;
  int get currentIndex => _currentIndex;
  List<Track> get queue => _queue;
  bool get isPlaying => _isPlaying;
  bool get isBuffering => _isBuffering;
  Duration get position => _position;
  Duration get duration => _duration;
  double get volume => _volume;
  LoopMode get loopMode => _loopMode;
  bool get shuffleEnabled => _shuffleEnabled;
  List<Track> get favorites => _favorites;
  List<Track> get recentlyPlayed => _recentlyPlayed;
  String get playbackError => _playbackError;
  String? get currentCanvasVideoUrl => _currentCanvasVideoUrl;

  /// Loads library lists (favorites, recently played) from local storage.
  void _loadLibrary() {
    _favorites = _storageService.getFavorites();
    _recentlyPlayed = _storageService.getRecentlyPlayed();
    notifyListeners();
  }

  /// Establishes listeners to react to native audio player state changes.
  void _initStreams() {
    _audioService.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      _isBuffering =
          state.processingState == ProcessingState.buffering ||
          state.processingState == ProcessingState.loading;

      // Automatically skip to the next song when playback completes
      if (state.processingState == ProcessingState.completed) {
        skipNext();
      }
      notifyListeners();
    });

    _audioService.durationStream.listen((dur) {
      _duration = dur ?? Duration.zero;
      notifyListeners();
    });

    _audioService.positionStream.listen((pos) {
      // Throttle position updates to reduce rebuild frequency
      final now = DateTime.now();
      if (_lastPositionUpdate == null ||
          now.difference(_lastPositionUpdate!).inMilliseconds >=
              _positionUpdateThrottle.inMilliseconds) {
        _position = pos;
        _lastPositionUpdate = now;
        notifyListeners();
      }
    });

    _audioService.volumeStream.listen((vol) {
      _volume = vol;
      notifyListeners();
    });

    _audioService.loopModeStream.listen((mode) {
      _loopMode = mode;
      notifyListeners();
    });

    _audioService.shuffleModeEnabledStream.listen((enabled) {
      _shuffleEnabled = enabled;
      notifyListeners();
    });
  }

  /// Sets the active queue and begins playback of the chosen track.

  void _prefetchNextTrack() {
    if (_queue.isEmpty || _currentIndex == -1) return;
    int nextIndex = _currentIndex + 1;
    if (nextIndex >= _queue.length) {
      if (_loopMode == LoopMode.all) {
        nextIndex = 0;
      } else {
        return;
      }
    }
    final nextTrack = _queue[nextIndex];
    debugPrint('🔄 Prefetching next track: ${nextTrack.title}');
    // Just calling this will populate the cache in YoutubeMusicService
    _musicService.getAudioStreamUrl(nextTrack.id);
  }

  Future<void> playTrack(Track track, List<Track> tracks) async {
    _playRequestCounter++;
    final currentRequestId = _playRequestCounter;

    _queue = List.from(tracks);
    _currentTrack = track;
    _currentIndex = _queue.indexWhere((t) => t.id == track.id);

    // Set favorite status based on local storage cache
    _currentTrack!.isFavorite = isFavorited(track.id);

    // Save to recently played list
    _addToRecentlyPlayed(track);

    // Update UI immediately to show buffering state for new track
    _isPlaying = false;
    _isBuffering = true;
    _playbackError = '';
    _currentCanvasVideoUrl = null; // Reset video url before fetching new one
    notifyListeners();

    // Stop old audio
    await _audioService.stop();

    try {
      debugPrint(
        '🎵 Getting stream URL for track: ${track.title} (${track.id})',
      );
      final streamUrl = await _musicService.getAudioStreamUrl(track.id);

      // If a newer track was requested while fetching, abort this one
      if (currentRequestId != _playRequestCounter) {
        debugPrint(
          '⏭️ Aborting play request for ${track.title} (superseded by newer request)',
        );
        return;
      }

      if (streamUrl != null) {
        debugPrint(
          '▶️  Playing URL: ${streamUrl.substring(0, streamUrl.length.clamp(0, 80))}...',
        );
        await _audioService.playUrl(streamUrl);
        _prefetchNextTrack();
        
        // Fetch canvas video in background
        _musicService.getVideoStreamUrl(track.id).then((videoUrl) {
          if (videoUrl != null && _currentTrack?.id == track.id) {
            _currentCanvasVideoUrl = videoUrl;
            notifyListeners();
          }
        });
      } else {
        _playbackError = 'Could not load stream for "${track.title}"';
        _isPlaying = false;
        notifyListeners();
      }
    } catch (e) {
      if (currentRequestId != _playRequestCounter) return;
      debugPrint('❌ Playback error: $e');
      _playbackError =
          'Playback failed: ${e.toString().substring(0, e.toString().length.clamp(0, 80))}';
      _isPlaying = false;
      notifyListeners();
    }
  }

  /// Toggles between playing and paused states.
  Future<void> togglePlay() async {
    if (_isPlaying) {
      await _audioService.pause();
    } else {
      if (_currentTrack != null) {
        await _audioService.play();
      }
    }
  }

  /// Skips to the next track in the queue.
  Future<void> skipNext() async {
    if (_queue.isEmpty || _currentIndex == -1) return;

    int nextIndex = _currentIndex + 1;
    if (nextIndex >= _queue.length) {
      if (_loopMode == LoopMode.all) {
        nextIndex = 0;
      } else {
        return; // End of playlist
      }
    }

    _currentIndex = nextIndex;
    final nextTrack = _queue[_currentIndex];
    await playTrack(nextTrack, _queue);
  }

  /// Skips to the previous track or restarts the current track.
  Future<void> skipPrevious() async {
    if (_queue.isEmpty || _currentIndex == -1) return;

    // Restart track if it has played for more than 3 seconds
    if (_position.inSeconds > 3) {
      await seek(Duration.zero);
      return;
    }

    int prevIndex = _currentIndex - 1;
    if (prevIndex < 0) {
      if (_loopMode == LoopMode.all) {
        prevIndex = _queue.length - 1;
      } else {
        prevIndex = 0; // Stay at beginning
      }
    }

    _currentIndex = prevIndex;
    final prevTrack = _queue[_currentIndex];
    await playTrack(prevTrack, _queue);
  }

  /// Seeks to a specific location in the timeline.
  Future<void> seek(Duration pos) async {
    await _audioService.seek(pos);
  }

  /// Sets the volume.
  Future<void> setVolume(double vol) async {
    await _audioService.setVolume(vol);
  }

  /// Cycles through loop modes (Off -> Repeat Playlist -> Repeat Song).
  Future<void> toggleLoopMode() async {
    LoopMode nextMode;
    if (_loopMode == LoopMode.off) {
      nextMode = LoopMode.all;
    } else if (_loopMode == LoopMode.all) {
      nextMode = LoopMode.one;
    } else {
      nextMode = LoopMode.off;
    }
    await _audioService.setLoopMode(nextMode);
  }

  /// Toggles state of shuffle mode.
  Future<void> toggleShuffle() async {
    final nextState = !_shuffleEnabled;
    await _audioService.setShuffleModeEnabled(nextState);
  }

  /// Verifies if track is favorited.
  bool isFavorited(String id) {
    return _favorites.any((t) => t.id == id);
  }

  /// Toggles favorite status and updates local database cache.
  Future<void> toggleFavorite(Track track) async {
    final index = _favorites.indexWhere((t) => t.id == track.id);

    if (index >= 0) {
      _favorites.removeAt(index);
      if (_currentTrack?.id == track.id) {
        _currentTrack!.isFavorite = false;
      }
    } else {
      track.isFavorite = true;
      _favorites.add(track);
      if (_currentTrack?.id == track.id) {
        _currentTrack!.isFavorite = true;
      }
    }

    await _storageService.saveFavorites(_favorites);
    notifyListeners();
  }

  /// Adds a track to the front of the recently played list.
  void _addToRecentlyPlayed(Track track) async {
    _recentlyPlayed.removeWhere((t) => t.id == track.id);
    _recentlyPlayed.insert(0, track);

    // Limit storage history list size to 20 tracks
    if (_recentlyPlayed.length > 20) {
      _recentlyPlayed = _recentlyPlayed.sublist(0, 20);
    }

    await _storageService.saveRecentlyPlayed(_recentlyPlayed);
  }
}
