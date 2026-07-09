import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  try {
    final _ = await yt.search.search('trending music');
    // print('search query success: ${searchResults.length}');
  } catch (e) {
    // print('search query failed: $e');
  }

  try {
    // Try catching individual items if it's an iterable?
    final _ = await yt.search.search('trending music');
    // print('search success: ${searchResults2.length}');
  } catch (e) {
    // print('search failed: $e');
  }
  yt.close();
}
