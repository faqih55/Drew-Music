import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/playback_provider.dart';
import 'explore_screen.dart';
import 'home_screen_playlist.dart';
import 'search_screen.dart';
import 'profile_screen.dart';
import 'player_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const Color primary = Color(0xFFCABEFF);
  static const Color onSurface = Color(0xFFE2E2E2);
  static const Color onSurfaceVariant = Color(0xFFC9C4D7);

  final List<_NavItem> _navItems = const [
    _NavItem(
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore,
      label: 'Eksplorasi',
    ),
    _NavItem(
      icon: Icons.queue_music_outlined,
      activeIcon: Icons.queue_music,
      label: 'Daftar Putar',
    ),
    _NavItem(icon: Icons.search, activeIcon: Icons.search, label: 'Cari'),
    _NavItem(icon: Icons.history, activeIcon: Icons.history, label: 'Riwayat'),
    _NavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -1.0),
                radius: 1.5,
                colors: [Color(0xFF31217E), Color(0xFF121414)],
                stops: [0.0, 0.7],
              ),
            ),
          ),

          // Atmospheric Glows - Wrapped in RepaintBoundary for performance
          RepaintBoundary(
            child: Stack(
              children: [
                Positioned(
                  top: -100,
                  left: -50,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.15),
                          blurRadius: 120,
                          spreadRadius: 60,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: -80,
                  right: -40,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF4837A1,
                          ).withValues(alpha: 0.15),
                          blurRadius: 120,
                          spreadRadius: 60,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Page Content - Smooth Transition
          Stack(
            children: List.generate(5, (index) {
              final isSelected = _selectedIndex == index;
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                opacity: isSelected ? 1.0 : 0.0,
                child: IgnorePointer(
                  ignoring: !isSelected,
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    scale: isSelected ? 1.0 : 0.96,
                    child: Builder(
                      builder: (context) {
                        switch (index) {
                          case 0: return const ExploreScreen();
                          case 1: return const PlaylistScreen();
                          case 2: return const SearchScreen();
                          case 3: return const HistoryScreen();
                          case 4: return const ProfileScreen();
                          default: return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ),
              );
            }),
          ),

          // Mini Player - Optimized with Selector to reduce rebuilds
          Consumer<PlaybackProvider>(
            builder: (context, playbackProvider, _) {
              if (playbackProvider.currentTrack == null) {
                return const SizedBox.shrink();
              }

              return Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 124,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(PlayerScreen.route());
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: RepaintBoundary(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withValues(alpha: 0.15),
                                  Colors.white.withValues(alpha: 0.02),
                                ],
                              ),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.15),
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 30,
                                  spreadRadius: -5,
                                ),
                                BoxShadow(
                                  color: primary.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: const Color(0xFF1E2020),
                                      image:
                                          playbackProvider
                                              .currentTrack!
                                              .albumArtUrl
                                              .isNotEmpty
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                playbackProvider
                                                    .currentTrack!
                                                    .albumArtUrl,
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          playbackProvider.currentTrack!.title,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: onSurface,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          playbackProvider.currentTrack!.artist,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: onSurfaceVariant.withValues(
                                              alpha: 0.7,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.skip_previous,
                                          color: onSurface,
                                          size: 22,
                                        ),
                                        onPressed: () =>
                                            playbackProvider.skipPrevious(),
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            playbackProvider.togglePlay(),
                                        child: Container(
                                          width: 38,
                                          height: 38,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: primary.withValues(
                                              alpha: 0.2,
                                            ),
                                          ),
                                          child: Icon(
                                            playbackProvider.isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            color: primary,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.skip_next,
                                          color: onSurface,
                                          size: 22,
                                        ),
                                        onPressed: () =>
                                            playbackProvider.skipNext(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value:
                                      playbackProvider.duration.inMilliseconds >
                                          0
                                      ? playbackProvider
                                                .position
                                                .inMilliseconds /
                                            playbackProvider
                                                .duration
                                                .inMilliseconds
                                      : 0,
                                  backgroundColor: Colors.white.withValues(
                                    alpha: 0.1,
                                  ),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        primary,
                                      ),
                                  minHeight: 4,
                                ),
                              ),
                            ],
                          ),
                        ), // End Container
                      ), // End BackdropFilter
                    ), // End RepaintBoundary
                  ),
                ),
              ),
              );
            },
          ),

          // Bottom Nav Dock - Optimized with RepaintBoundary
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 36),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9999),
                child: RepaintBoundary(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.15),
                            Colors.white.withValues(alpha: 0.02),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(9999),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 30,
                            spreadRadius: -5,
                          ),
                          BoxShadow(
                            color: primary.withValues(alpha: 0.1),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(_navItems.length, (index) {
                        final item = _navItems[index];
                        final isActive = _selectedIndex == index;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedIndex = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive
                                  ? primary.withValues(alpha: 0.1)
                                  : Colors.transparent,
                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                        color: primary.withValues(alpha: 0.4),
                                        blurRadius: 15,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isActive ? item.activeIcon : item.icon,
                                  color: isActive
                                      ? primary
                                      : onSurfaceVariant.withValues(alpha: 0.7),
                                  size: 24,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: isActive
                                        ? FontWeight.w700
                                        : FontWeight.normal,
                                    color: isActive
                                        ? primary
                                        : onSurfaceVariant.withValues(
                                            alpha: 0.7,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    ), // End Container
                  ), // End BackdropFilter
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
