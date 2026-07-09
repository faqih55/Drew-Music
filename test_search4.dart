import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  try {
    final _ = await yt.search.search('trending music');
    // print('search() success: ${searchResults.length}');
  } catch (e) {
    // print('search() failed: $e');
  }
  yt.close();
}
