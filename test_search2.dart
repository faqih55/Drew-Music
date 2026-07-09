import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  try {
    // print('Trying getVideos()...');
    final _ = await yt.search.search(
      'top 100 trending music hits official audio',
    );
    // print('getVideos() success: ${videos.length}');
  } catch (e) {
    // print('getVideos() failed: $e');
  }

  try {
    // print('Trying search()...');
    final _ = await yt.search.search(
      'top 100 trending music hits official audio',
    );
    // print('search() success: ${search.length}');
  } catch (e) {
    // print('search() failed: $e');
  }
  yt.close();
}
