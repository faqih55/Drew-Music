import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/track.dart';

class OfficialThumbnail extends StatefulWidget {
  final Track track;
  final BoxFit fit;

  const OfficialThumbnail({
    super.key,
    required this.track,
    this.fit = BoxFit.cover,
  });

  @override
  State<OfficialThumbnail> createState() => _OfficialThumbnailState();
}

class _OfficialThumbnailState extends State<OfficialThumbnail> {
  String? _realAlbumArtUrl;

  @override
  void initState() {
    super.initState();
    _fetchRealAlbumArt();
  }

  @override
  void didUpdateWidget(covariant OfficialThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.track.id != widget.track.id) {
      _realAlbumArtUrl = null;
      _fetchRealAlbumArt();
    }
  }

  Future<void> _fetchRealAlbumArt() async {
    try {
      final query = Uri.encodeComponent(
        '${widget.track.title} ${widget.track.artist}'.replaceAll(
          RegExp(r'[\(\)\[\]]'),
          '',
        ),
      );
      final url =
          'https://itunes.apple.com/search?term=$query&entity=song&limit=1';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final art = data['results'][0]['artworkUrl100'].replaceAll(
            '100x100',
            '600x600',
          );
          if (mounted) {
            setState(() {
              _realAlbumArtUrl = art;
            });
          }
        }
      }
    } catch (e) {
      // Ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _realAlbumArtUrl ?? widget.track.albumArtUrl;

    return imageUrl.isNotEmpty
        ? Image.network(
            imageUrl,
            fit: widget.fit,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: Colors.black26),
          )
        : const Icon(Icons.music_note, color: Colors.white38);
  }
}
