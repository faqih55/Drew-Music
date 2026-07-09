import 'dart:ui';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  static const Color primary = Color(0xFFCABEFF);
  static const Color onSurface = Color(0xFFE2E2E2);
  static const Color onSurfaceVariant = Color(0xFFC9C4D7);

  bool _isCleared = false;

  void _clearHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF282A2B),
        title: const Text('Clear History', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to clear your listening history?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: primary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isCleared = true;
              });
            },
            child: const Text('Clear', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({required Widget child, double borderRadius = 16, EdgeInsetsGeometry? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.15),
                Colors.white.withValues(alpha: 0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 0.5),
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
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by home_screen
      body: SafeArea(
        child: Column(
          children: [
            // Top AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(), // Spacer if needed
                  _BouncingButton(
                    onTap: _clearHistory,
                    child: _buildGlassCard(
                      borderRadius: 9999,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.delete_sweep, color: onSurface, size: 18),
                          const SizedBox(width: 8),
                          const Text(
                            'CLEAR HISTORY',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Main Content
            Expanded(
              child: _isCleared
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history, size: 64, color: onSurfaceVariant.withValues(alpha: 0.2)),
                          const SizedBox(height: 16),
                          const Text(
                            'No History Found',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: onSurface),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Start listening to build your collection.',
                            style: TextStyle(fontSize: 14, color: onSurfaceVariant),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        // Today Group
                        const Text(
                          'TODAY',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.0,
                            color: Colors.white54,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const _TrackHistoryCard(
                          title: 'Midnight Echoes',
                          artist: 'Neon Void • Synthwave Essentials',
                          time: '2:15 PM',
                          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBsS3m4cUW5ThX402KO2trPgw094_7mdLcGZga-J8DiwtgmjOz6BD0pAOD59oyPrJV-NR0bBUIWwvaq-JzKjgWHqWmUyXY5vvZmm7hxwRRFFhx9ZHsIxW19wc81hw_CJeP-JGYumNRa31htOj_-jb2eTb4cB97e3KWoX2hUgw1JUFOYWgnrlH02IO_0_h5tI9Hzcj-drdJrOLLbg4xpuJlIMcvBD0k9Q5E_aUXDXBoptZSsyhFd1ExpwCa2_3Y_Ow5bbzpELHvwLzY',
                          isRecent: true,
                        ),
                        const SizedBox(height: 12),
                        const _TrackHistoryCard(
                          title: 'Fluid Dynamics',
                          artist: 'Archaic Waves',
                          time: '11:40 AM',
                          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBlbfEdx9N6HUVgfdE-gGF8F99yIWTyoaQSQ2YzsuqyUyuw_AGEimcEUNda2fyNW2oNaby03ZInUq4GndmaAekT6RNIQaDTB8P_2AZz6vmrbvXBkS1HmKeIw6x-A4FwFyitE61iPfsQ1q_Tj2OD_EO-FEkx30RxTmQw-WXT5_VSE5146Z6hqFgbGBna4R7nfybi3wfB-P7iR2E_T65rFsIUX-nLUBWHBEdtwYZsJzTMCLe-waxKj5hVkgcMvTWJyKJnnXKkrO-T1yM',
                        ),
                        const SizedBox(height: 12),
                        const _TrackHistoryCard(
                          title: 'Rainy Rooftops',
                          artist: 'Lofi Dreams',
                          time: '09:12 AM',
                          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDHm2humXoFshD6D8cGhMlnAu8X0fOUYpa9129NIW1mxb3-vCYLZb_yR1Xds2w7dFO9arJm81Yu3asYtcGY3MN9HTaML9xOI6bw3s2hhT5mT5kii8TCW4iqiHvmcNBgDKSRbExAXjLiBi5WYLDk0_RUJQL9TqtO6-jxbzfLxoKDuE8OWUYawIgSAbm3CkMqwUCr-RaQqvX9cKgrE3q2rCzCROKZ4TD3zt1KfpkVpr1FA-fh2gBrB_Nkdbxvd6m3tjgllwTY1ILW6lY',
                        ),
                        const SizedBox(height: 40),
                        
                        // Yesterday Group
                        const Text(
                          'YESTERDAY',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.0,
                            color: Colors.white54,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const _TrackHistoryCard(
                          title: 'Digital Horizon',
                          artist: 'Cyber Pulse',
                          time: 'Oct 24, 10:20 PM',
                          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAbgefgUfefQt6j8S_VpyaEkIKT427GYWDCv9trscJ2jeLQydhtob9ijFPmHx_ZLLv0XasjghS6a-8JdZRpVuf0Ij0MZEJWaBkJP2hAzoz7BFUSfUwHxXRqzzyMzcew3r6XStm-pU9ReTNb7efLSQWRjeXoHajQBgxUFdGJjYIx55fKLCHZIajd3YhN5iOAQaav6Bg57rq9s-Zpaho4bKChwbJCMTt1p6--UJE-mIt1-rfGo5hovNB2BHOp2bb8a0bjUzSdIkLQm5I',
                        ),
                        const SizedBox(height: 12),
                        const _TrackHistoryCard(
                          title: 'Analog Drift',
                          artist: 'The Sound Sculptors',
                          time: 'Oct 24, 08:45 PM',
                          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCfp8pQuBGxszU55_JdS6JEbxslc7yCnwBbXyCg0Uu5OM8zjkzkm-NZkBaifzHGteAQ5AqZpYmghRx5jatecepGLxdwHhJbFz4Augx57v5rhTV8smh20r-MBA65e3Zhc9vp3TGblpqCr-StypjyMIXvIB1mYN6-vim4dfRdaQrAYN3TE7uafFgBPdyfRF3SI_JmofClsDvj0bByQW617UQS04aQ0E0q_JaWuySeXaKVjIWRs288Xi2uYm8jf2XbHT1Wpt_unRYxGFo',
                        ),
                        const SizedBox(height: 12),
                        const _TrackHistoryCard(
                          title: 'Celestial Path',
                          artist: 'Ethereal Journey',
                          time: 'Oct 24, 05:30 PM',
                          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBsIR22M7az-FJZtJP5Vk4f2WT9eXDme4LvJNNnKlbo7TEnClQIGjlpEO8YF7_heCeoeP6348XRfjBUX3YihCrNx5IVnME3BDQquZqVML6UT8lg9fGHAE-hnEG3jthG4rV3JatdiCqsgRYeKVUJ3orlJKlg8rzK0u-DroDKcy7YkPw9QkaDytUEzNI4HRugB4YBdU17ktRdttqpvQ8utl2PnXvoypdSFYx5tkzL4TdJfYlwJhFK64Abm0j5qzamU24lCJC4mK4gGME',
                        ),
                        const SizedBox(height: 32),
                        
                        // Load Older
                        Center(
                          child: _BouncingButton(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9999),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                              ),
                              child: const Text(
                                'LOAD OLDER HISTORY',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                  color: onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 120), // Bottom padding for nav bar
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackHistoryCard extends StatelessWidget {
  final String title;
  final String artist;
  final String time;
  final String imageUrl;
  final bool isRecent;

  const _TrackHistoryCard({
    required this.title,
    required this.artist,
    required this.time,
    required this.imageUrl,
    this.isRecent = false,
  });

  @override
  Widget build(BuildContext context) {
    return _BouncingButton(
      onTap: () {},
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.02),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 30,
                  spreadRadius: -5,
                ),
                BoxShadow(
                  color: _HistoryScreenState.primary.withValues(alpha: 0.1),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 56,
                      height: 56,
                      color: Colors.white12,
                      child: const Icon(Icons.music_note, color: Colors.white54),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _HistoryScreenState.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        artist,
                        style: const TextStyle(
                          fontSize: 14,
                          color: _HistoryScreenState.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: isRecent ? _HistoryScreenState.primary : _HistoryScreenState.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BouncingButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _BouncingButton({required this.child, required this.onTap});

  @override
  State<_BouncingButton> createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<_BouncingButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}
