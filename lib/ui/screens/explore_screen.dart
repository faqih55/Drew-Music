import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/track.dart';
import '../../providers/music_provider.dart';
import '../../providers/playback_provider.dart';
import 'home_screen_playlist.dart';
import 'player_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  static const Color primary = Color(0xFFCABEFF);
  static const Color onSurface = Color(0xFFE2E2E2);
  static const Color onSurfaceVariant = Color(0xFFC9C4D7);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<MusicProvider>().loadRecommendations();
      }
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) {
      return 'Selamat Pagi';
    } else if (hour < 15) {
      return 'Selamat Siang';
    } else if (hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  String _generateMixTitle(List<Track> tracks, String defaultTitle) {
    if (tracks.isEmpty) return defaultTitle;
    final firstArtist = tracks.first.artist;
    if (firstArtist.isNotEmpty) {
      return 'Mix $firstArtist';
    }
    return defaultTitle;
  }

  String _generateMixSubtitle(List<Track> tracks, String defaultSubtitle) {
    if (tracks.isEmpty) return defaultSubtitle;
    final artists = tracks
        .map((t) => t.artist)
        .where((a) => a.isNotEmpty)
        .toSet()
        .toList();
    if (artists.isEmpty) return defaultSubtitle;
    if (artists.length <= 2) return artists.join(', ');
    return '${artists[0]}, ${artists[1]}, dan lainnya';
  }



  Widget _glass({required Widget child, double radius = 16}) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.05),
                blurRadius: 4,
              ),
            ],
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
    final tracks = musicProvider.recommendations;

    return RefreshIndicator(
      color: primary,
      backgroundColor: const Color(0xFF1E1F22),
      onRefresh: () async {
        await context.read<MusicProvider>().loadRecommendations(force: true);
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getGreeting(),
                  style: const TextStyle(
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

        // Playlists Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 12),
            child: const Text(
              'Daftar Putar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: onSurface,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 280,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildPlaylistCard(
                  context,
                  title: _generateMixTitle(tracks, 'Mix Musik Baru'),
                  subtitle: _generateMixSubtitle(tracks, 'MUSIK UNTUKMU'),
                  imageUrl:
                      tracks.isNotEmpty && tracks.first.albumArtUrl.isNotEmpty
                      ? tracks.first.albumArtUrl
                      : 'https://lh3.googleusercontent.com/aida-public/AB6AXuBdaRmRnO0VetgYKlgejhO2LMJAMOUeVabqfuax2UmnvfH70QibcdqgAShPo9cs7diMDHHOBY1mrbdTPPjcP_GFFhHW2rkI_2Ef-85HU2Tj82DsptoHfXAjmI0GuVS7qgWTvF6cHWzHuWtLTiZO7pjYuCNXWovxi7W4GPfR3hKe34ob9ugEKr_1W4BmyyaCgJq6UqxGovYGViUpSo2t5dd2IWFvX-wWmjStklVpfKlxK2jgBpzVJmzS6At0GZwrnT2Zibw8JQ04hcs',
                  isPrimary: true,
                  tracks: tracks,
                  playbackProvider: playbackProvider,
                ),
                const SizedBox(width: 16),
                _buildPlaylistCard(
                  context,
                  title: _generateMixTitle(
                    playbackProvider.favorites,
                    'Mix Favorit',
                  ),
                  subtitle: _generateMixSubtitle(
                    playbackProvider.favorites,
                    'MUSIK FAVORITMU',
                  ),
                  imageUrl:
                      playbackProvider.favorites.isNotEmpty &&
                          playbackProvider
                              .favorites
                              .first
                              .albumArtUrl
                              .isNotEmpty
                      ? playbackProvider.favorites.first.albumArtUrl
                      : 'https://lh3.googleusercontent.com/aida-public/AB6AXuA6CSmUC1X940AGOXcSg93iF1nGKoHmgdZJWdXsfSZ5rmY_Bbrf4ojdDOgzQzeHwMYWow0n3MlGPMqBd8v0qtW2HEaX0bIoRJvOdfw_qkJkxkCF_ymSwbGsvt03sOT_-QFiCLJAcHB2Bx_GTBvz00h50J_Cc5b0fo_KBvvQw6NAnrwfi7iOGmqNG-uQRQNo2u2fkXQ6QPnEE5IiGQXYd0AP4-9ywyv02H4gZ9J-IXrrhAb_8BYEFey07OKq307CJ59T8lPd2xQdU4E',
                  isPrimary: false,
                  tracks: playbackProvider.favorites,
                  playbackProvider: playbackProvider,
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ),

        // Best New Songs Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            child: const Text(
              'Lagu baru terbaik',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: onSurface,
              ),
            ),
          ),
        ),

        if (musicProvider.isLoadingRecommendations)
          const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CupertinoActivityIndicator(color: primary, radius: 16),
              ),
            ),
          )
        else if (tracks.isNotEmpty)
          ..._buildGroupedTracks(context, tracks, playbackProvider, musicProvider),

        const SliverToBoxAdapter(child: SizedBox(height: 200)),
      ],
    ),
    );
  }

  List<Widget> _buildGroupedTracks(BuildContext context, List<Track> allTracks, PlaybackProvider playbackProvider, MusicProvider musicProvider) {
    if (allTracks.isEmpty) return [];

    List<Widget> slivers = [];
    
    // --- 1. Top Section: Horizontal Carousel (Quick Access style) ---
    // Take up to 14 tracks for the grid
    final gridTracks = allTracks.take(14).toList();
    if (gridTracks.isNotEmpty) {
      Widget buildTrackCard(Track track) {
        final isCurrent = playbackProvider.currentTrack?.id == track.id;
        return GestureDetector(
          onTap: () {
            playbackProvider.playTrack(track, allTracks);
            Navigator.of(context).push(PlayerScreen.route());
          },
          child: SizedBox(
            width: 170,
            height: 56,
            child: _glass(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      color: const Color(0xFF1E2020),
                      child: track.albumArtUrl.isNotEmpty
                          ? Image.network(track.albumArtUrl, fit: BoxFit.cover)
                          : const Icon(Icons.music_note, color: Colors.white38),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          track.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isCurrent ? primary : onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 12),
            child: SizedBox(
              height: 120, // 56 + 8 + 56
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: (gridTracks.length / 2).ceil(),
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final int firstIndex = index * 2;
                  final int secondIndex = firstIndex + 1;
                  final hasSecond = secondIndex < gridTracks.length;
                  return Column(
                    children: [
                      buildTrackCard(gridTracks[firstIndex]),
                      if (hasSecond) ...[
                        const SizedBox(height: 8),
                        buildTrackCard(gridTracks[secondIndex]),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
    }

    // --- 2. Carousel Sections ---
    final categorizedMap = musicProvider.categorizedRecommendations;

    for (var entry in categorizedMap.entries) {
      final categoryTitle = entry.key;
      final groupTracks = entry.value;
      
      if (groupTracks.isNotEmpty) {
        // Title
        slivers.add(
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Text(
                categoryTitle,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: onSurface),
              ),
            ),
          ),
        );
        
        // Horizontal Carousel
        slivers.add(
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: groupTracks.length,
                itemBuilder: (context, index) {
                  final track = groupTracks[index];
                  final isCurrent = playbackProvider.currentTrack?.id == track.id;
                  
                  return GestureDetector(
                    onTap: () {
                      playbackProvider.playTrack(track, groupTracks);
                      Navigator.of(context).push(PlayerScreen.route());
                    },
                    child: Container(
                      width: 140,
                      margin: const EdgeInsets.only(right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: const Color(0xFF1E2020),
                              image: track.albumArtUrl.isNotEmpty
                                  ? DecorationImage(image: NetworkImage(track.albumArtUrl), fit: BoxFit.cover)
                                  : null,
                            ),
                            child: track.albumArtUrl.isEmpty
                                ? const Icon(Icons.music_note, color: Colors.white38, size: 40)
                                : null,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            track.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isCurrent ? primary : onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            track.artist,
                            style: TextStyle(
                              fontSize: 12,
                              color: onSurfaceVariant.withValues(alpha: 0.8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }
    }

    return slivers;
  }

  Widget _buildPlaylistCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String imageUrl,
    required bool isPrimary,
    required List<Track> tracks,
    required PlaybackProvider playbackProvider,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PlaylistScreen(
              title: title,
              subtitle: subtitle,
              imageUrl: imageUrl,
              tracks: tracks,
            ),
          ),
        );
      },
      child: Container(
        width: 256,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xCC121414)],
                    stops: [0.4, 1.0],
                  ),
                ),
              ),
              Positioned(
                bottom: 24,
                left: 24,
                right: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isPrimary
                            ? const Color(0xFFCABEFF)
                            : const Color(0xFFCABEFF).withValues(alpha: 0.2),
                        border: isPrimary
                            ? null
                            : Border.all(
                                color: const Color(
                                  0xFFCABEFF,
                                ).withValues(alpha: 0.3),
                              ),
                        boxShadow: isPrimary
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFFCABEFF,
                                  ).withValues(alpha: 0.3),
                                  blurRadius: 20,
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: isPrimary
                            ? const Color(0xFF31009A)
                            : const Color(0xFFCABEFF),
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
