import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  final queries = [
    'pop hits official',
    'top songs playlist',
    'justin bieber songs',
    'spotify top 50 global',
    'billboard hot 100',
  ];

  for (var q in queries) {
    try {
      final _ = await yt.search.search(q, filter: TypeFilters.video);
      // print('"$q" success: ${res.length}');
    } catch (e) {
      // print('"$q" failed: $e');
    }
  }
  yt.close();
}
