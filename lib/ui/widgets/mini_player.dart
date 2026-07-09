import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/playback_provider.dart';
import '../screens/player_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final playbackProvider = context.watch<PlaybackProvider>();
    final currentTrack = playbackProvider.currentTrack;

    if (currentTrack == null) {
      return const SizedBox.shrink(); // Hide the bar if no track is loaded
    }

    // Calculate thin bottom progress value (0.0 to 1.0)
    double progress = 0.0;
    if (playbackProvider.duration.inMilliseconds > 0) {
      progress =
          playbackProvider.position.inMilliseconds /
          playbackProvider.duration.inMilliseconds;
    }
    progress = progress.clamp(0.0, 1.0);

    return Positioned(
      left: 12,
      right: 12,
      bottom:
          MediaQuery.of(context).padding.bottom +
          8, // Respect Safe Area notch on iOS
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const PlayerScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Slide up transition matching standard music players
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    const curve = Curves.easeOutCubic;
                    var tween = Tween(
                      begin: begin,
                      end: end,
                    ).chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 12.0,
              sigmaY: 12.0,
            ), // Glassmorphism frosted look
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 0.8,
                ),
              ),
              child: Stack(
                children: [
                  // Content Row
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      children: [
                        // Song artwork
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: currentTrack.albumArtUrl.isNotEmpty
                              ? Image.network(
                                  currentTrack.albumArtUrl,
                                  width: 46,
                                  height: 46,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 46,
                                  height: 46,
                                  color: AppConstants.surfaceLight,
                                  child: const Icon(
                                    CupertinoIcons.music_note,
                                    color: AppConstants.spotifyGreen,
                                    size: 22,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 12),

                        // Title / artist info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                currentTrack.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                currentTrack.artist,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppConstants.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // Like heart button
                        IconButton(
                          icon: Icon(
                            playbackProvider.isFavorited(currentTrack.id)
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart,
                            color: playbackProvider.isFavorited(currentTrack.id)
                                ? AppConstants.spotifyGreen
                                : Colors.white,
                            size: 22,
                          ),
                          onPressed: () {
                            playbackProvider.toggleFavorite(currentTrack);
                          },
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),

                        // Play/Pause button
                        IconButton(
                          icon: Icon(
                            playbackProvider.isPlaying
                                ? CupertinoIcons.pause_fill
                                : CupertinoIcons.play_fill,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {
                            playbackProvider.togglePlay();
                          },
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ],
                    ),
                  ),

                  // Micro progress timeline bar at bottom
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 0,
                    child: Container(
                      height: 2.5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppConstants.spotifyGreen,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
