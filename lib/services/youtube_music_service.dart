import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../models/track.dart';
import 'package:flutter/foundation.dart';

class YoutubeMusicService {
  final YoutubeExplode _yt = YoutubeExplode();
  final Map<String, String> _streamCache = {};

  String _cleanTitle(String rawTitle) {
    String clean = rawTitle;

    // 1. Remove text inside parentheses or brackets, e.g., (Official Video), [Audio]
    clean = clean.replaceAll(RegExp(r'\[.*?\]'), '');
    clean = clean.replaceAll(RegExp(r'\(.*?\)'), '');

    // 2. If it follows the 'Artist - Title' format, take the part after ' - '
    if (clean.contains(' - ')) {
      final parts = clean.split(' - ');
      if (parts.length > 1) {
        clean = parts
            .sublist(1)
            .join(' - '); // Keep everything after the first ' - '
      }
    }

    // 3. Also remove common suffixes like "Official Video", "Lyric Video" if not in parentheses
    clean = clean.replaceAll(
      RegExp(
        r'official video|official music video|lyric video|official audio|audio',
        caseSensitive: false,
      ),
      '',
    );

    return clean.trim();
  }

  /// Search for songs on YouTube and return a list of Tracks.


  Future<List<Track>> searchTracks(String query) async {
    try {
      // Use TypeFilters.video to prevent crashes on Playlists/Mixes (getT bug)
      // and prevent getVideos FormatException on Livestream durations.
      final searchResults = await _yt.search.search(
        query,
        filter: TypeFilters.video,
      );
      // Filter out compilations, long mixes (> 6 mins), and empty durations
      final filteredResults = searchResults.where((video) {
        final duration = video.duration;
        if (duration == null) return false;
        
        final durationInMinutes = duration.inMinutes;
        if (durationInMinutes > 6) return false; // Exclude anything longer than 6 minutes
        
        final lowerTitle = video.title.toLowerCase();
        if (lowerTitle.contains('full album') || 
            lowerTitle.contains('mix') || 
            lowerTitle.contains('compilation') ||
            lowerTitle.contains('mashup')) {
          return false;
        }
        
        return true;
      });

      return filteredResults.map((video) {
        return Track.fromYouTube(
          id: video.id.value,
          title: _cleanTitle(video.title),
          artist: video.author,
          album: 'YouTube Music',
          durationMs: video.duration?.inMilliseconds ?? 0,
          albumArtUrl: video.thumbnails.highResUrl,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error searching YouTube: $e');
      return [];
    }
  }

  /// Get recommendations by searching for popular terms across different genres and return them by category
  Future<Map<String, List<Track>>> getCategorizedRecommendations() async {
    final Map<String, String> queriesMap = {
      'lagu pop indonesia terbaru official': 'Top Musik Indonesia',
      'top hits indonesia official': 'Top Hits Indonesia',
      'lagu galau indonesia terpopuler': 'Trending Musik Galau',
      'trending music worldwide official': 'Trending Global',
      'global top 50 music hits official': 'Global Top 50',
      'viral hits tiktok official audio': 'Viral TikTok Audio',
      'billboard hot 100 top hits official': 'Billboard Hot 100 Populer',
      'kpop trending hits official': 'K-Pop Trending Hits',
      'latin pop hits official': 'Latin Pop & Internasional',
      'us uk top chart official': 'Top Hits Global (US/UK)'
    };
    
    final queries = queriesMap.keys.toList();
    
    // Shuffle the list of genres and pick 8 to get a huge dataset for many categories
    queries.shuffle();
    final selectedQueries = queries.take(8).toList();
    
    final Map<String, List<Track>> categorizedData = {};
    
    try {
      final List<List<Track>> results = await Future.wait(
        selectedQueries.map((q) => searchTracks(q))
      );
      
      for (int i = 0; i < selectedQueries.length; i++) {
        final query = selectedQueries[i];
        final title = queriesMap[query]!;
        
        // Shuffle the tracks inside each category so it feels fresh
        final tracks = results[i];
        tracks.shuffle();
        
        categorizedData[title] = tracks;
      }
      
      return categorizedData;
    } catch (e) {
      debugPrint('Error fetching categorized recommendations: $e');
      // Fallback
      final fallbackTracks = await searchTracks('pop hits official');
      return {'Lagu Pop Pilihan': fallbackTracks};
    }
  }

  /// Get related tracks based on an artist name
  Future<List<Track>> getRelatedTracks(String artistName) async {
    try {
      final safeArtist = artistName.replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), '');
      return await searchTracks('$safeArtist best songs official audio');
    } catch (e) {
      debugPrint('Error fetching related tracks for $artistName: $e');
      return [];
    }
  }

  /// Get the best playable audio stream URL for a given video ID.
  ///
  /// Strategy:
  /// 1. Try audio-only streams (opus/webm or mp4a/mp4) sorted by bitrate.
  ///    iOS AVFoundation can play `mp4a` (AAC) in m4a/mp4 containers natively.
  /// 2. Fall back to lowest-quality muxed stream (mp4) if no audio-only works.
  Future<String?> getAudioStreamUrl(String videoId) async {
    if (_streamCache.containsKey(videoId)) {
      debugPrint('⚡ Using cached stream URL for: $videoId');
      return _streamCache[videoId];
    }
    try {
      debugPrint('🎵 Fetching stream manifest for: $videoId');
      final manifest = await _yt.videos.streamsClient.getManifest(videoId);

      // --- Attempt 1: muxed mp4 stream (video+audio, lowest res) ---
      // iOS AVPlayer often rejects YouTube's DASH/fragmented audio-only streams with an unknown error (-1).
      // Standard muxed MP4 streams usually play without issues.
      final muxed = manifest.muxed
          .where((s) => s.codec.mimeType.contains('mp4'))
          .toList();

      if (muxed.isNotEmpty) {
        // Use the lowest bitrate muxed stream to save bandwidth
        muxed.sort((a, b) => a.bitrate.compareTo(b.bitrate));
        final url = muxed.first.url.toString();
        debugPrint(
          '✅ Using muxed mp4 stream: ${muxed.first.qualityLabel} @ ${muxed.first.bitrate}',
        );
        _streamCache[videoId] = url;
        _streamCache[videoId] = url;
        return url;
      }

      // --- Attempt 2: audio-only mp4a (AAC) streams ---
      final audioOnlyMp4 = manifest.audioOnly
          .where(
            (s) =>
                s.codec.mimeType.contains('mp4') ||
                s.codec.mimeType.contains('m4a'),
          )
          .toList();

      if (audioOnlyMp4.isNotEmpty) {
        // Use LOWEST bitrate for reduced data usage and faster streaming
        audioOnlyMp4.sort((a, b) => a.bitrate.compareTo(b.bitrate));
        final url = audioOnlyMp4.first.url.toString();
        debugPrint(
          '⚠️ Using mp4a audio-only stream: ${audioOnlyMp4.first.codec.mimeType} @ ${audioOnlyMp4.first.bitrate} (optimized)',
        );
        _streamCache[videoId] = url;
        _streamCache[videoId] = url;
        return url;
      }

      // --- Attempt 3: any audio-only stream ---
      if (manifest.audioOnly.isNotEmpty) {
        // Use LOWEST bitrate fallback to reduce data usage
        final audioStreams = manifest.audioOnly.toList();
        audioStreams.sort((a, b) => a.bitrate.compareTo(b.bitrate));
        final stream = audioStreams.first;
        final url = stream.url.toString();
        debugPrint(
          '⚠️ Using fallback audio-only stream: ${stream.codec.mimeType} @ ${stream.bitrate} (optimized)',
        );
        _streamCache[videoId] = url;
        _streamCache[videoId] = url;
        return url;
      }

      debugPrint('❌ No playable stream found for $videoId');
      return null;
    } catch (e) {
      debugPrint('❌ Error getting stream URL for $videoId: $e');
      return null;
    }
  }

  Future<String?> getVideoStreamUrl(String videoId) async {
    try {
      final manifest = await _yt.videos.streamsClient.getManifest(videoId);
      
      // We want a fast, low-res video stream for Canvas to save bandwidth.
      final videoStreams = manifest.videoOnly.where((e) => e.qualityLabel == '360p' || e.qualityLabel == '480p');
      if (videoStreams.isNotEmpty) {
        return videoStreams.first.url.toString();
      }
      if (manifest.muxed.isNotEmpty) {
        return manifest.muxed.first.url.toString();
      }
      return null;
    } catch (e) {
      debugPrint('Error getting video stream: $e');
      return null;
    }
  }

  void dispose() {
    _yt.close();
  }
}
