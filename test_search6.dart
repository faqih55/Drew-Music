import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  try {
    final _ = await yt.search.search(
      'trending music',
      filter: TypeFilters.video,
    );
    // print('search(filter: video) success: ${searchResults.length}');
  } catch (e) {
    // print('search(filter: video) failed: $e');
  }
  yt.close();
}
