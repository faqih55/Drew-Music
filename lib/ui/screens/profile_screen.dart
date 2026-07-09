import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/playback_provider.dart';
import '../../providers/auth_provider.dart';
import '../widgets/login_view.dart';
import 'player_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color primary = Color(0xFFCABEFF);
  static const Color onSurface = Color(0xFFE2E2E2);
  static const Color onSurfaceVariant = Color(0xFFC9C4D7);

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
    final auth = context.watch<AuthProvider>();
    final playbackProvider = context.watch<PlaybackProvider>();
    final recentlyPlayed = playbackProvider.recentlyPlayed;

    if (!auth.isAuthenticated) {
      return _buildLoggedOutView(context, auth);
    }

    final user = auth.currentUser!;

    final topArtists = [
      {
        'name': 'Ariana Grande',
        'time': '12h listened',
        'url':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCcAYvFpeAcAhao7sHmpoE-abgWT0Gyjm-N-JFu2OB07QuLrabXVM6Zll-UARNCdPS6erNxd6M6z1BItQvkfgQlVg0v8WjEhiuQpcbs_Le_SgNGR_ZxZ0cCwpxdZ_MhxYlPVqC-wAlNg6OSiv8bXHkO3WwHcPtTGvp6t3QMmigCDjn6hoyN3rLiaHl4t9H9oBTh1QOzVDmz0IiYxpUCtUcUQUSSRsrqk7sCsqQKT4p6Ncrxkyl06srBByjUVRe1vbvLvGS79UoTROM',
      },
      {
        'name': 'EMBRZ',
        'time': '8.4h listened',
        'url':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCq5kFdv3DovztpkNOK1DR97rivr0Ga56Edwy-kiCZ504R8ADBx90N9pEF77x0KIkb6QUGX_rvbYmB0k5aB7LJfxVByap-0DKuHTdKbiJ-r7Uoejl6UK54oK1TT_yEtZ31Zcn5hTN_rG5DBmKPr9cGBswzhNixKZOphnefu0dRc8u-yGW_lhxl6acB-0QpHk-RufGEbjcI-wXWKTS1iHVB-_BhxFJW4ILUbc5SjYvwd_maPKGLcGG_rpzcvcGKk0-q4Yg7OAIBPaqA',
      },
      {
        'name': 'Jarami',
        'time': '5.2h listened',
        'url':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuD6OKbD2boWsk4MEHDOA3UmEDEUeMfdCTQxpHLfoMpnXP9hQkiy1zle-LwsArDKRk4TxACZuLQWEEaWjNWA6U85jU4rUFS8ZZcYwbK6ogCOyjklI_NgeBN3Galu9pGc-L2U7-v7szh930LI9g0x3YrXa7PPbra9o57Djc5NxCiFOnM7h2_UNkfk77seFtBshJuBp4DGHlpq3MrjLdon7-iAdGfd6EZ3EGxc4cTnWBG-g_dPHyxd5_hWQRWluUMjomHp0L5UbvPNQ3M',
      },
      {
        'name': 'Tyga',
        'time': '4.9h listened',
        'url':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuB81G01MnIcvyfPUSiZHuOCYSluIFkHa5HIa1D5mtAkthJIdAiyqAe7JvSXPInvkGM6CSzLF18zk-e6r_0VHiYqjJJQ57mVnt6IKg6Yh8YtmFaLYzkX5P8J8meNy5O75K53EAAICtrDjo74ygISZDyUSkKqcOYaxfobCtMc0JQx17LDobMBuas_s7DdtY2eES6GG49WRbg4W42YS0LUagob7Jg4ysw_3i2vctAXRGoF5c1ghKzBCP2cqnLpsE5O1FjmGzFtcPnMUUU',
      },
    ];

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Profil',
                  style: TextStyle(
                    fontSize: 28,
                    letterSpacing: -0.28,
                    fontWeight: FontWeight.w800,
                    color: onSurface,
                  ),
                ),
                _glass(
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(Icons.settings, color: onSurface, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ),

        // User Identity
        SliverToBoxAdapter(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 128,
                    height: 128,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF947DFF).withValues(alpha: 0.4),
                          const Color(0xFF300099).withValues(alpha: 0.2),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.2),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                            user.photoURL ?? 'https://ui-avatars.com/api/?name=${user.displayName ?? 'User'}',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primary,
                      border: Border.all(
                        color: const Color(0xFF121414),
                        width: 4,
                      ),
                    ),
                    child: const Icon(
                      Icons.verified,
                      color: Color(0xFF31009A),
                      size: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                user.displayName ?? user.email ?? 'Pengguna',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: onSurface,
                ),
              ),
              Text(
                'Music Lover',
                style: TextStyle(
                  fontSize: 14,
                  color: onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _statItem('2.4k', 'FOLLOWERS'),
                  const SizedBox(width: 48),
                  _statItem('182', 'FOLLOWING'),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      auth.logout();
                    },
                    child: Container(
                      width: 120,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: const Center(
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _glass(
                    child: const SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(Icons.share, color: onSurface, size: 20),
                    ),
                    radius: 999,
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),

        // Top Artists
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Artists',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: onSurface,
                  ),
                ),
                const Text(
                  'View All',
                  style: TextStyle(
                    color: primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: topArtists
                  .map(
                    (artist) => _glass(
                      radius: 24,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(artist['url']!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              artist['name']!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: onSurface,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              artist['time']!,
                              style: TextStyle(
                                fontSize: 10,
                                color: onSurfaceVariant.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),

        // Recently Played
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: const Text(
              'Recently Played',
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
          sliver: recentlyPlayed.isEmpty
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        'Play a song to see it here',
                        style: TextStyle(
                          color: onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final track = recentlyPlayed[index];
                    final isCurrent =
                        playbackProvider.currentTrack?.id == track.id;
                    return GestureDetector(
                      onTap: () {
                        playbackProvider.playTrack(track, recentlyPlayed);
                        Navigator.of(context).push(PlayerScreen.route());
                      },
                      child: _glass(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: const Color(0xFF1E2020),
                                      image: track.albumArtUrl.isNotEmpty
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                track.albumArtUrl,
                                              ),
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
                                  if (isCurrent)
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(
                                            alpha: 0.5,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      track.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: onSurface,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${track.artist} • Single',
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
                              Text(
                                'Recently',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: onSurfaceVariant.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }, childCount: recentlyPlayed.length),
                ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 200)),
      ],
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
            color: onSurfaceVariant.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildLoggedOutView(BuildContext context, AuthProvider auth) {
    return LoginView(auth: auth);
  }
}
