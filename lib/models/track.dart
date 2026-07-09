class Track {
  final String id;
  final String title;
  final String artist;
  final String album;
  final int durationMs;
  final String albumArtUrl;
  final String? previewUrl;
  bool isFavorite;

  Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.durationMs,
    required this.albumArtUrl,
    this.previewUrl,
    this.isFavorite = false,
  });

  /// Factory constructor to create a track from YouTube data.
  factory Track.fromYouTube({
    required String id,
    required String title,
    required String artist,
    required String album,
    required int durationMs,
    required String albumArtUrl,
  }) {
    return Track(
      id: id,
      title: title,
      artist: artist,
      album: album,
      durationMs: durationMs,
      albumArtUrl: albumArtUrl,
      previewUrl: null,
      isFavorite: false,
    );
  }

  /// Converts a Track instance into a map for local storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'durationMs': durationMs,
      'albumArtUrl': albumArtUrl,
      'previewUrl': previewUrl,
      'isFavorite': isFavorite,
    };
  }

  /// Factory constructor to parse a track from locally stored Map.
  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      artist: map['artist'] as String? ?? '',
      album: map['album'] as String? ?? '',
      durationMs: map['durationMs'] as int? ?? 0,
      albumArtUrl: map['albumArtUrl'] as String? ?? '',
      previewUrl: map['previewUrl'] as String?,
      isFavorite: map['isFavorite'] as bool? ?? false,
    );
  }
}
