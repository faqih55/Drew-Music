import '../../models/track.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../providers/playback_provider.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  static Route route() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const PlayerScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;
        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  String _selectedDeviceName = 'IPHONE INI';
  IconData _selectedDeviceIcon = Icons.phone_iphone;

  // Colors from the HTML mockup
  static const Color primary = Color(0xFFCABEFF);
  static const Color primaryContainer = Color(0xFF947DFF);
  static const Color onPrimaryContainer = Color(0xFF2A0088);
  static const Color onSurface = Color(0xFFE2E2E2);
  static const Color onSurfaceVariant = Color(0xFFC9C4D7);

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    final playbackProvider = context.read<PlaybackProvider>();
    if (playbackProvider.isPlaying) {
      _rotationController.repeat();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  Widget _buildGlassCard({required Widget child, double borderRadius = 9999}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFCABEFF).withValues(alpha: 0.1),
              blurRadius: 8,
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  void _showLyrics(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF121414).withValues(alpha: 0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: Material(
              type: MaterialType.transparency,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Lirik',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Lirik lagu belum tersedia untuk trek ini.\n\nSilakan nikmati musiknya!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white54,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _setDevice(String name, IconData icon) {
    setState(() {
      _selectedDeviceName = name;
      _selectedDeviceIcon = icon;
    });
    Navigator.pop(context);
  }

  void _showDevices(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF121414).withValues(alpha: 0.95),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),
              child: Material(
                type: MaterialType.transparency,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Perangkat Tersedia',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: Icon(
                        Icons.phone_iphone,
                        color: _selectedDeviceName == 'IPHONE INI'
                            ? primary
                            : Colors.white,
                      ),
                      title: Text(
                        'iPhone Ini',
                        style: TextStyle(
                          color: _selectedDeviceName == 'IPHONE INI'
                              ? primary
                              : Colors.white,
                          fontWeight: _selectedDeviceName == 'IPHONE INI'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      trailing: _selectedDeviceName == 'IPHONE INI'
                          ? const Icon(Icons.check, color: primary)
                          : null,
                      onTap: () => _setDevice('IPHONE INI', Icons.phone_iphone),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.headphones,
                        color: _selectedDeviceName == 'AIRPODS MAX'
                            ? primary
                            : Colors.white,
                      ),
                      title: Text(
                        'AirPods Max',
                        style: TextStyle(
                          color: _selectedDeviceName == 'AIRPODS MAX'
                              ? primary
                              : Colors.white,
                          fontWeight: _selectedDeviceName == 'AIRPODS MAX'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      trailing: _selectedDeviceName == 'AIRPODS MAX'
                          ? const Icon(Icons.check, color: primary)
                          : null,
                      onTap: () => _setDevice('AIRPODS MAX', Icons.headphones),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.speaker,
                        color: _selectedDeviceName == 'SPEAKER RUANG TAMU'
                            ? primary
                            : Colors.white,
                      ),
                      title: Text(
                        'Speaker Ruang Tamu',
                        style: TextStyle(
                          color: _selectedDeviceName == 'SPEAKER RUANG TAMU'
                              ? primary
                              : Colors.white,
                          fontWeight:
                              _selectedDeviceName == 'SPEAKER RUANG TAMU'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      trailing: _selectedDeviceName == 'SPEAKER RUANG TAMU'
                          ? const Icon(Icons.check, color: primary)
                          : null,
                      onTap: () =>
                          _setDevice('SPEAKER RUANG TAMU', Icons.speaker),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showQueue(BuildContext context) {
    final playbackProvider = context.read<PlaybackProvider>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.only(top: 24),
          decoration: BoxDecoration(
            color: const Color(0xFF121414).withValues(alpha: 0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: Material(
              type: MaterialType.transparency,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Antrean Lagu',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: playbackProvider.queue.length,
                    itemBuilder: (context, index) {
                      final track = playbackProvider.queue[index];
                      final isCurrent =
                          track.id == playbackProvider.currentTrack?.id;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 4,
                        ),
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: track.albumArtUrl.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(track.albumArtUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            color: Colors.white12,
                          ),
                        ),
                        title: Text(
                          track.title,
                          style: TextStyle(
                            color: isCurrent ? primary : Colors.white,
                            fontWeight: isCurrent
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          track.artist,
                          style: TextStyle(color: Colors.white54),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: isCurrent
                            ? Icon(Icons.graphic_eq, color: primary, size: 20)
                            : null,
                        onTap: () {
                          // Jump to queue index
                          playbackProvider.playTrack(
                            track,
                            playbackProvider.queue,
                          );
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }





  @override
  Widget build(BuildContext context) {
    final playbackProvider = context.watch<PlaybackProvider>();
    final currentTrack = playbackProvider.currentTrack;

    if (currentTrack == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF121414),
        body: Center(
          child: Text(
            'No song selected',
            style: TextStyle(color: onSurfaceVariant),
          ),
        ),
      );
    }

    if (playbackProvider.isPlaying) {
      if (!_rotationController.isAnimating) {
        _rotationController.repeat();
      }
    } else {
      if (_rotationController.isAnimating) {
        _rotationController.stop();
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          if (playbackProvider.currentCanvasVideoUrl != null && playbackProvider.currentCanvasVideoUrl!.isNotEmpty)
            Positioned.fill(
              child: _CanvasVideoBackground(videoUrl: playbackProvider.currentCanvasVideoUrl!),
            )
          else ...[
            // Background Gradient (Fixed behind scroll)
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.0, -1.0),
                  radius: 1.5,
                  colors: [
                    Color(0xFF2F1787),
                    Color(0xFF121414),
                  ],
                  stops: [0.0, 0.7],
                ),
              ),
            ),
            
            // Background Atmospheric Glows (Fixed behind scroll)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.1,
              left: -30,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary.withValues(alpha: 0.2),
                  boxShadow: [
                    BoxShadow(color: primary.withValues(alpha: 0.2), blurRadius: 100, spreadRadius: 50)
                  ]
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.2,
              right: -30,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF4837A1).withValues(alpha: 0.2),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF4837A1).withValues(alpha: 0.2), blurRadius: 120, spreadRadius: 50)
                  ]
                ),
              ),
            ),
          ],

          // Dark overlay for readability when Canvas is playing
          if (playbackProvider.currentCanvasVideoUrl != null && playbackProvider.currentCanvasVideoUrl!.isNotEmpty)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.4),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                      Colors.black.withValues(alpha: 0.9),
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
              ),
            ),

          // Scrollable Content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      // Top AppBar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _BouncingButton(
                              onTap: () => Navigator.of(context).pop(),
                              child: _buildGlassCard(
                                child: const SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Icon(Icons.expand_more, color: onSurface),
                                ),
                              ),
                            ),
                            const Column(
                              children: [
                                Text(
                                  'PLAYING FROM PLAYLIST',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                    color: onSurfaceVariant,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Mix Musik Baru',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: onSurface,
                                  ),
                                ),
                              ],
                            ),
                            _BouncingButton(
                              onTap: () {
                                _showMoreOptions(context, currentTrack);
                              },
                              child: _buildGlassCard(
                                child: const SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Icon(Icons.more_horiz, color: onSurface),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Album Art (Takes remaining flexible space)
                      Expanded(
                        child: playbackProvider.currentCanvasVideoUrl != null && playbackProvider.currentCanvasVideoUrl!.isNotEmpty
                            ? const SizedBox() // Empty space to push controls down
                            : Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                                child: Center(
                                  child: AspectRatio(
                                    aspectRatio: 1.0,
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        AnimatedBuilder(
                                          animation: _rotationController,
                                          builder: (context, child) {
                                            return Transform.rotate(
                                              angle: _rotationController.value * 2 * 3.141592653589793,
                                              child: child,
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: 0.3),
                                                  blurRadius: 32,
                                                  spreadRadius: 0,
                                                  offset: const Offset(0, 8),
                                                ),
                                              ],
                                            ),
                                            child: ClipOval(
                                              child: currentTrack.albumArtUrl.isNotEmpty
                                                  ? Image.network(currentTrack.albumArtUrl, fit: BoxFit.cover, errorBuilder: (_, _, _) => Container(color: Colors.black26))
                                                  : Container(color: Colors.black26, child: const Icon(Icons.music_note, size: 80, color: Colors.white54)),
                                            ),
                                          ),
                                        ),
                                        // Disc center hole
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: const Color(0xFF1E2020),
                                            border: Border.all(color: Colors.white24, width: 1),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(alpha: 0.5),
                                                blurRadius: 4,
                                                spreadRadius: 2,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                      ),

                      // Controls Section (Pinned at bottom of SliverFillRemaining)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          children: [
                            // Song Title & Artist & Favorite
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentTrack.title,
                                        style: const TextStyle(
                                          fontSize: 26,
                                          height: 1.2,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: -0.28,
                                          color: onSurface,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        currentTrack.artist,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: onSurfaceVariant,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => playbackProvider.toggleFavorite(currentTrack),
                                  child: _buildGlassCard(
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: Icon(
                                        playbackProvider.isFavorited(currentTrack.id)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: playbackProvider.isFavorited(currentTrack.id)
                                            ? primary
                                            : onSurface,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Progress Bar
                            ProgressBar(
                              progress: playbackProvider.position,
                              buffered: null,
                              total: playbackProvider.duration,
                              progressBarColor: primary,
                              baseBarColor: Colors.white.withValues(alpha: 0.1),
                              bufferedBarColor: Colors.transparent,
                              thumbColor: Colors.white,
                              thumbRadius: 8,
                              thumbGlowRadius: 20,
                              thumbGlowColor: primary.withValues(alpha: 0.6),
                              timeLabelLocation: TimeLabelLocation.below,
                              timeLabelPadding: 12,
                              timeLabelTextStyle: const TextStyle(
                                color: onSurfaceVariant,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                              onSeek: (duration) {
                                playbackProvider.seek(duration);
                              },
                            ),
                            const SizedBox(height: 12),

                            // Play Controls
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.shuffle,
                                    color: playbackProvider.shuffleEnabled ? primary : onSurfaceVariant.withValues(alpha: 0.6),
                                    size: 24,
                                  ),
                                  onPressed: () => playbackProvider.toggleShuffle(),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.skip_previous, color: onSurface, size: 32),
                                  onPressed: () => playbackProvider.skipPrevious(),
                                ),
                                GestureDetector(
                                  onTap: () => playbackProvider.togglePlay(),
                                  child: Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: primaryContainer,
                                      boxShadow: [
                                        BoxShadow(
                                          color: primary.withValues(alpha: 0.3),
                                          blurRadius: 20,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: playbackProvider.isBuffering
                                          ? const SizedBox(
                                              width: 32,
                                              height: 32,
                                              child: CupertinoActivityIndicator(
                                                color: Colors.white,
                                                radius: 12,
                                              ),
                                            )
                                          : Icon(
                                              playbackProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                                              color: onPrimaryContainer,
                                              size: 40,
                                            ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.skip_next, color: onSurface, size: 32),
                                  onPressed: () => playbackProvider.skipNext(),
                                ),
                                IconButton(
                                  icon: Icon(
                                    playbackProvider.loopMode == LoopMode.one
                                        ? Icons.repeat_one
                                        : Icons.repeat,
                                    color: playbackProvider.loopMode != LoopMode.off
                                        ? primary
                                        : onSurfaceVariant.withValues(alpha: 0.6),
                                    size: 24,
                                  ),
                                  onPressed: () => playbackProvider.toggleLoopMode(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Bottom Indicator Shell (Glassmorphic Dock)
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0, bottom: 24.0),
                        child: _buildGlassCard(
                          borderRadius: 9999,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _BouncingButton(
                                  onTap: () => _showLyrics(context),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Icon(Icons.lyrics_outlined, color: onSurfaceVariant, size: 20),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _BouncingButton(
                                  onTap: () => _showDevices(context),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Icon(_selectedDeviceIcon, color: primary, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          _selectedDeviceName,
                                          style: const TextStyle(
                                            color: primary,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _BouncingButton(
                                  onTap: () => _showQueue(context),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Icon(Icons.queue_music, color: onSurfaceVariant, size: 20),
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

              // ==============================
              // ADDITIONAL SCROLLABLE CONTENT
              // ==============================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 48.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCreditsSection(currentTrack),
                      const SizedBox(height: 32),
                      _buildRelatedMusicSection(context, currentTrack),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showMoreOptions(BuildContext context, Track track) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1F22).withValues(alpha: 0.9),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            // Track Info
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    track.albumArtUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 48,
                      height: 48,
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
                        track.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        track.artist,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(color: Colors.white12),
            // Options
            ListTile(
              leading: const Icon(Icons.favorite_border, color: Colors.white),
              title: const Text('Add to Favorites', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to Favorites')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.playlist_add, color: Colors.white),
              title: const Text('Add to Playlist', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to Playlist')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.white),
              title: const Text('Share', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditsSection(Track? track) {
    if (track == null) return const SizedBox();
    
    // Generate some mock stats for a realistic feel based on the track ID length or characters
    final mockListeners = (track.id.codeUnits.fold<int>(0, (a, b) => a + b) * 12345 % 9876543) + 100000;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Music Credits',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                'Show all',
                style: TextStyle(
                  color: primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.artist.isNotEmpty ? track.artist : 'Unknown Artist',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Penyanyi utama',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Follow',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white12),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${mockListeners.toString().replaceAllMapped(RegExp(r"\\B(?=(\\d{3})+(?!\\d))"), (match) => ".")} Pendengar',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pendengar Bulanan',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Produksi',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${track.artist} Official',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedMusicSection(BuildContext context, Track? track) {
    return const SizedBox();
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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

class _CanvasVideoBackground extends StatefulWidget {
  final String videoUrl;
  const _CanvasVideoBackground({required this.videoUrl});
  @override
  State<_CanvasVideoBackground> createState() => _CanvasVideoBackgroundState();
}

class _CanvasVideoBackgroundState extends State<_CanvasVideoBackground> {
  VideoPlayerController? _videoController;
  String? _initializedUrl;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_CanvasVideoBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoUrl != oldWidget.videoUrl) {
      _initializeVideo(widget.videoUrl);
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeVideo(widget.videoUrl);
  }

  Future<void> _initializeVideo(String url) async {
    if (_initializedUrl == url) return;
    _initializedUrl = url;
    
    final oldController = _videoController;
    final newController = VideoPlayerController.networkUrl(Uri.parse(url));
    
    try {
      await newController.initialize();
      // Seek to 1/3 of the video to get a more interesting clip instead of intros
      final duration = newController.value.duration;
      final startPos = Duration(seconds: (duration.inSeconds / 3).floor());
      await newController.seekTo(startPos);
      await newController.setVolume(0); // Canvas is silent
      await newController.play();
      
      newController.addListener(() {
        if (!mounted) return;
        // Loop back after 5 seconds
        if (newController.value.position > startPos + const Duration(seconds: 5)) {
          newController.seekTo(startPos);
        }
      });
      
      if (mounted) {
        setState(() {
          _videoController = newController;
        });
      }
      
      // Dispose old controller after new one is ready
      oldController?.dispose();
    } catch (e) {
      debugPrint('Error initializing canvas video: $e');
      newController.dispose();
      if (_initializedUrl == url) {
        _initializedUrl = null;
        if (mounted) setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_videoController != null && _videoController!.value.isInitialized) {
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _videoController!.value.size.width,
            height: _videoController!.value.size.height,
            child: VideoPlayer(_videoController!),
          ),
        ),
      );
    }

    return Container(color: Colors.black);
  }
}
