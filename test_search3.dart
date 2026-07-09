import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  final queries = [
    'pop hits',
    'trending music',
    'top songs',
    'popular music playlist',
    'new music 2024',
  ];

  for (var q in queries) {
    try {
      final _ = await yt.search.search(q);
      // print('search("$q") success: ${videos.length}');
    } catch (e) {
      // print('search("$q") failed');
    }
  }
  yt.close();
}
