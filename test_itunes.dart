import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  final queries = [
    'LuzXr3He9NI Best TikTok Songs',
    'Justin Bieber Beauty and a Beat',
    'Ariana Grande we cant be friends',
  ];

  for (var q in queries) {
    try {
      final query = Uri.encodeComponent(q);
      final url =
          'https://itunes.apple.com/search?term=$query&entity=song&limit=1';
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        final _ = data['results'][0]['artworkUrl100'].replaceAll(
          '100x100',
          '600x600',
        );
        // print('"$q" art: $art');
      } else {
        // '$q' not found
      }
    } catch (e) {
      // '$q' error occurred
    }
  }
}
