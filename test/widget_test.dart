import 'package:flutter_test/flutter_test.dart';
import 'package:music_player/models/track.dart';

void main() {
  group('Track Model Tests', () {
    test('Track.fromYouTube should correctly parse YouTube video data', () {
      final track = Track(
        id: 'test_track_id',
        title: 'Breathe',
        artist: 'Pink Floyd',
        album: 'The Dark Side of the Moon',
        albumArtUrl: 'https://example.com/album_art.jpg',
        durationMs: 163000,
        previewUrl: '',
        isFavorite: false,
      );

      expect(track.id, 'test_track_id');
      expect(track.title, 'Breathe');
      expect(track.artist, 'Pink Floyd');
      expect(track.album, 'The Dark Side of the Moon');
      expect(track.albumArtUrl, 'https://example.com/album_art.jpg');
      expect(track.durationMs, 163000);
      expect(track.isFavorite, isFalse);
    });

    test('Track.toMap and fromMap serialization roundtrip', () {
      final track = Track(
        id: '123',
        title: 'Time',
        artist: 'Pink Floyd',
        album: 'Dark Side',
        durationMs: 421000,
        albumArtUrl: 'https://example.com/time.jpg',
        previewUrl: 'https://example.com/time_preview.mp3',
        isFavorite: true,
      );

      final map = track.toMap();
      final parsedTrack = Track.fromMap(map);

      expect(parsedTrack.id, '123');
      expect(parsedTrack.title, 'Time');
      expect(parsedTrack.artist, 'Pink Floyd');
      expect(parsedTrack.album, 'Dark Side');
      expect(parsedTrack.albumArtUrl, 'https://example.com/time.jpg');
      expect(parsedTrack.durationMs, 421000);
      expect(parsedTrack.previewUrl, 'https://example.com/time_preview.mp3');
      expect(parsedTrack.isFavorite, isTrue);
    });
  });
}
