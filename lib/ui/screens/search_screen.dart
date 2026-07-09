import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/music_provider.dart';
import '../../providers/playback_provider.dart';
import 'player_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  static const Color primary = Color(0xFFCABEFF);
  static const Color onSurface = Color(0xFFE2E2E2);
  static const Color onSurfaceVariant = Color(0xFFC9C4D7);

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Pop',
      'gradient': [const Color(0xFFFF6B6B), const Color(0xFF556270)],
      'icon': Icons.music_note,
    },
    {
      'name': 'Rock',
      'gradient': [const Color(0xFF4837A1), const Color(0xFF121414)],
      'icon': Icons.electric_bolt,
    },
    {
      'name': 'Electronic',
      'gradient': [const Color(0xFF00D2FF), const Color(0xFF3A7BD5)],
      'icon': Icons.speaker,
    },
    {
      'name': 'Chill',
      'gradient': [const Color(0xFFA8FF78), const Color(0xFF78FFD6)],
      'icon': Icons.coffee,
    },
    {
      'name': 'Jazz',
      'gradient': [const Color(0xFFF2994A), const Color(0xFFF2C94C)],
      'icon': Icons.piano,
    },
    {
      'name': 'Hip-Hop',
      'gradient': [const Color(0xFF8E2DE2), const Color(0xFF4A00E0)],
      'icon': Icons.mic_external_on,
    },
  ];

  final List<String> _suggestions = [
    'Taylor Swift',
    'Bruno Mars',
    'Coldplay',
    'The Weeknd',
    'K-Pop Hits',
    'Acoustic',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      if (mounted) context.read<MusicProvider>().search(query);
    });
  }

  Widget _glass({required Widget child, double radius = 16}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(radius),
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final musicProvider = context.watch<MusicProvider>();
    final playbackProvider = context.watch<PlaybackProvider>();
    final hasQuery = _searchController.text.trim().isNotEmpty;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            child: Row(
              children: [
                const Text(
                  'Pencarian',
                  style: TextStyle(
                    fontSize: 28,
                    letterSpacing: -0.28,
                    fontWeight: FontWeight.w800,
                    color: onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Search Bar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: _glass(
              radius: 999,
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: onSurface, fontSize: 16),
                onChanged: (v) {
                  _onSearchChanged(v);
                  setState(() {});
                },
                onTap: () => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Songs, artists, albums...',
                  hintStyle: TextStyle(
                    color: onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  prefixIcon: const Icon(Icons.search, color: onSurfaceVariant),
                  suffixIcon: hasQuery
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: onSurfaceVariant,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            context.read<MusicProvider>().clearSearch();
                            setState(() {});
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Suggestions
        if (!hasQuery)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _suggestions.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return GestureDetector(
                    onTap: () {
                      _searchController.text = suggestion;
                      context.read<MusicProvider>().search(suggestion);
                      setState(() {});
                    },
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1)),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          suggestion,
                          style: const TextStyle(
                            color: onSurface,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

        if (!hasQuery) ...[
          // Browse All
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: const Text(
                'Browse All',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: onSurface,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.6,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final cat = _categories[index];
                final colors = cat['gradient'] as List<Color>;
                return GestureDetector(
                  onTap: () {
                    _searchController.text = cat['name'];
                    context.read<MusicProvider>().search(cat['name']);
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cat['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Icon(
                            cat['icon'],
                            color: Colors.white.withValues(alpha: 0.5),
                            size: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }, childCount: _categories.length),
            ),
          ),
        ] else if (musicProvider.isLoadingSearch)
          const SliverFillRemaining(
            child: Center(
              child: CupertinoActivityIndicator(
                color: primary,
                radius: 16,
              ),
            ),
          )
        else if (musicProvider.searchResults.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: Column(
                children: [
                  Icon(
                    Icons.search_off,
                    size: 48,
                    color: onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tidak ada hasil',
                    style: TextStyle(color: onSurfaceVariant),
                  ),
                  Text(
                    'Try different keywords',
                    style: TextStyle(
                      color: onSurfaceVariant.withValues(alpha: 0.5),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final track = musicProvider.searchResults[index];
                final isCurrent = playbackProvider.currentTrack?.id == track.id;
                return InkWell(
                  onTap: () {
                    playbackProvider.playTrack(
                      track,
                      musicProvider.searchResults,
                    );
                    Navigator.of(context).push(PlayerScreen.route());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFF1E2020),
                            image: track.albumArtUrl.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(track.albumArtUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: track.albumArtUrl.isEmpty
                              ? const Icon(
                                  Icons.music_note,
                                  color: Colors.white38,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                track.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isCurrent ? primary : onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                track.artist,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: onSurfaceVariant.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (isCurrent && playbackProvider.isPlaying)
                          const Icon(
                            Icons.graphic_eq,
                            color: primary,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              }, childCount: musicProvider.searchResults.length),
            ),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 200)),
      ],
    );
  }
}
