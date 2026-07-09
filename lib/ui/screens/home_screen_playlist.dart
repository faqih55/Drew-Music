import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/track.dart';
import '../../providers/music_provider.dart';
import '../../providers/playback_provider.dart';
import 'player_screen.dart';

// Color constants
const Color _primary = Color(0xFFCABEFF);
const Color _onSurface = Color(0xFFE2E2E2);
const Color _onSurfaceVariant = Color(0xFFC9C4D7);

class PlaylistScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final List<Track>? tracks;

  const PlaylistScreen({
    super.key,
    this.title = 'Mix Musik Baru',
    this.subtitle = 'DIPILIH UNTUK ANDA',
    this.imageUrl =
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAT3QGRTMJ1M8Bgi7VLkGru5av33f4BRV0lcNiFjIo2G_-LR4ZJXqHh8X76bKfWlwPZZZwNzvrZ5qykhh-5G8rwBtBAnSJHlcNI5XJFT65wziRGtcULJ0MvdXKbzfnVzWuIISgzLuEIE9S_C3lVUrnlQmfusqLEnjNbgEYBRfP1du0Z9HF2PnD0omcgLP4Ar-u_O5lVkmN93SQR-GuNNJmULUxmuccoO9PZKPVn3IqxLGKV8Rnz_CdqnZRN8UlresMssEmLtd_VE1Q',
    this.tracks,
  });

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.tracks == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<MusicProvider>().loadRecommendations();
        }
      });
    }
  }

  Widget _glass({
    required Widget child,
    double radius = 16,
    double opacity = 0.05,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: opacity + 0.05),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.04),
              blurRadius: 4,
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final musicProvider = context.watch<MusicProvider>();
    final playbackProvider = context.watch<PlaybackProvider>();
    final tracks = widget.tracks ?? musicProvider.recommendations;

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            child: Row(
              children: [
                if (Navigator.canPop(context))
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        color: Colors.black26,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: _onSurface,
                        size: 20,
                      ),
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.subtitle,
                        style: const TextStyle(
                          fontSize: 10,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700,
                          color: _primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: _onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Cover Art Hero
        SliverToBoxAdapter(
          child: Center(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    image: DecorationImage(
                      image: NetworkImage(tracks.isNotEmpty && tracks.first.albumArtUrl.isNotEmpty ? tracks.first.albumArtUrl : widget.imageUrl),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _primary.withValues(alpha: 0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                ),
                // Badge
                Positioned(
                  bottom: 20,
                  child: _glass(
                    radius: 20,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Text(
                        'DOLBY ATMOS',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700,
                          color: _onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Subtitle
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 34,
                    letterSpacing: -0.68,
                    fontWeight: FontWeight.w700,
                    color: _onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Diperbarui Hari Ini • ${tracks.length} Lagu',
                  style: TextStyle(
                    fontSize: 14,
                    color: _onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Action Buttons
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (tracks.isNotEmpty) {
                      playbackProvider.playTrack(tracks.first, tracks);
                    }
                  },
                  child: Container(
                    width: 140,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: _primary,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: _primary.withValues(alpha: 0.25),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_arrow,
                          color: Color(0xFF31009A),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Putar Semua',
                          style: TextStyle(
                            color: Color(0xFF31009A),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    playbackProvider.toggleShuffle();
                    if (tracks.isNotEmpty) {
                      playbackProvider.playTrack(tracks.first, tracks);
                    }
                  },
                  child: _glass(
                    radius: 999,
                    opacity: 0.1,
                    child: const SizedBox(
                      width: 140,
                      height: 52,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shuffle, color: _onSurface, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Acak',
                            style: TextStyle(
                              color: _onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Track List
        if (widget.tracks == null && musicProvider.isLoadingRecommendations)
          const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CupertinoActivityIndicator(color: _primary, radius: 16),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final track = tracks[index];
                final isCurrent = playbackProvider.currentTrack?.id == track.id;
                return GestureDetector(
                  onTap: () {
                    playbackProvider.playTrack(track, tracks);
                    Navigator.of(context).push(PlayerScreen.route());
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isCurrent
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (isCurrent)
                          Container(
                            width: 4,
                            height: 40,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: _primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        Container(
                          width: 56,
                          height: 56,
                          margin: const EdgeInsets.only(right: 12),
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                track.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isCurrent ? _primary : _onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                track.artist,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _onSurfaceVariant.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                playbackProvider.isFavorited(track.id)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: playbackProvider.isFavorited(track.id)
                                    ? _primary
                                    : _onSurfaceVariant.withValues(alpha: 0.5),
                                size: 20,
                              ),
                              onPressed: () =>
                                  playbackProvider.toggleFavorite(track),
                            ),
                            const Icon(
                              Icons.more_horiz,
                              color: _onSurfaceVariant,
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }, childCount: tracks.length),
            ),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 200)),
      ],
    ),
    );
  }
}
