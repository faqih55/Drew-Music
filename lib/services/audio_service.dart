import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  bool _isBusy = false;

  AudioService() {
    _initAudioSession();
  }

  /// Configures the device's audio session for standard music playback.
  /// This ensures that hardware outputs, interruption states (e.g. phone calls),
  /// and iOS system behaviors are correctly respected.
  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  /// Exposes the underlying just_audio player instance.
  AudioPlayer get player => _player;

  /// Stream of player state updates (playing/paused, buffering, loaded).
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  /// Stream of current audio position changes.
  Stream<Duration> get positionStream => _player.positionStream;

  /// Stream of current track duration changes.
  Stream<Duration?> get durationStream => _player.durationStream;

  /// Stream of player volume changes.
  Stream<double> get volumeStream => _player.volumeStream;

  /// Stream of loop mode modifications.
  Stream<LoopMode> get loopModeStream => _player.loopModeStream;

  /// Stream of shuffle mode modifications.
  Stream<bool> get shuffleModeEnabledStream => _player.shuffleModeEnabledStream;

  /// Loads and plays a audio track preview URL.
  Future<void> playUrl(String url) async {
    // Drop lock if we take too long waiting
    int waitCycles = 0;
    while (_isBusy && waitCycles < 10) {
      await Future.delayed(const Duration(milliseconds: 50));
      waitCycles++;
    }
    _isBusy = true;
    try {
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(url),
          headers: {
            'User-Agent':
                'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1',
            'Accept': '*/*',
          },
        ),
      );
      await _player.play();
    } catch (e) {
      // Ignore -11800 if it was interrupted by another track
      if (!e.toString().contains('-11800')) {
        throw Exception('Failed to load track preview URL: $e');
      }
    } finally {
      _isBusy = false;
    }
  }

  /// Resumes playback of the current track.
  Future<void> play() async {
    await _player.play();
  }

  /// Pauses playback of the current track.
  Future<void> pause() async {
    await _player.pause();
  }

  /// Stops playback.
  Future<void> stop() async {
    _isBusy = false; // Release lock instantly so new playUrl can start
    try {
      await _player.pause();
      await _player.stop();
    } catch (e) {
      // Ignore
    }
  }

  /// Seeks to a specific timestamp in the track.
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  /// Adjusts the volume (from 0.0 to 1.0).
  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  /// Toggles loop modes (off, active song, entire playlist).
  Future<void> setLoopMode(LoopMode loopMode) async {
    await _player.setLoopMode(loopMode);
  }

  /// Toggles shuffle mode.
  Future<void> setShuffleModeEnabled(bool enabled) async {
    await _player.setShuffleModeEnabled(enabled);
  }

  /// Releases resources when the app or provider is destroyed.
  void dispose() {
    _player.dispose();
  }
}
