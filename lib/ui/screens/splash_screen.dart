import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/music_provider.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  FragmentProgram? _shaderProgram;
  late AnimationController _shaderTimeController;

  final List<String> _messages = [
    "MEMULAI AURA...",
    "MENYELARASKAN RITME...",
    "MENGHIDUPKAN IMERSI...",
    "SIAP UNTUK MUSIK."
  ];
  int _currentMessageIndex = 0;
  bool _showMessage = true;
  Timer? _messageTimer;
  
  late AnimationController _revealController;
  late Animation<double> _revealOpacity;
  late Animation<double> _revealTranslate;

  @override
  void initState() {
    super.initState();
    
    // Pre-load music database during splash screen so it's ready immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<MusicProvider>().loadRecommendations();
      }
    });

    _loadShader();
    
    _shaderTimeController = AnimationController(
      vsync: this,
      duration: const Duration(days: 999), // Run indefinitely
    )..forward();

    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _revealOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _revealController, curve: Curves.easeOutCubic),
    );
    _revealTranslate = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _revealController, curve: Curves.easeOutCubic),
    );

    _startMessageCycle();
  }

  void _loadShader() async {
    try {
      final program = await FragmentProgram.fromAsset('shaders/aura_shader.frag');
      if (mounted) {
        setState(() {
          _shaderProgram = program;
        });
      }
    } catch (e) {
      debugPrint('Error loading shader: \$e');
    }
  }

  void _startMessageCycle() {
    _messageTimer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      if (_currentMessageIndex < _messages.length - 1) {
        setState(() {
          _showMessage = false;
        });
        
        Future.delayed(const Duration(milliseconds: 700), () {
          if (mounted) {
            setState(() {
              _currentMessageIndex++;
              _showMessage = true;
            });
          }
        });
      } else {
        timer.cancel();
        // Transition to HomeScreen after final message is shown
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 1000),
              ),
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _shaderTimeController.dispose();
    _revealController.dispose();
    _messageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121414),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Shader
          if (_shaderProgram != null)
            AnimatedBuilder(
              animation: _shaderTimeController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _AuraShaderPainter(
                    shader: _shaderProgram!.fragmentShader(),
                    time: _shaderTimeController.lastElapsedDuration?.inMicroseconds.toDouble() ?? 0.0,
                  ),
                );
              },
            ),

          // Main Content
          SafeArea(
            child: AnimatedBuilder(
              animation: _revealController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _revealTranslate.value),
                  child: Opacity(
                    opacity: _revealOpacity.value,
                    child: child,
                  ),
                );
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Central Branding Cluster
                      const _LogoCluster(),
                      
                      const SizedBox(height: 32),
                      
                      // Brand Name & Tagline
                      Text(
                        'XDREW V1',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.68,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'RASAKAN ENERGINYA, TEMUKAN RITMEMU.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3.0,
                          color: const Color(0xFFC9C4D7).withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 96), // Spacing for footer
                      
                      // Footer / Loading State
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 700),
                        opacity: _showMessage ? 1.0 : 0.0,
                        child: Text(
                          _messages[_currentMessageIndex],
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.4,
                            color: const Color(0xFFCABEFF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuraShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final double time;

  _AuraShaderPainter({required this.shader, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, time / 1000.0); // Convert microseconds to milliseconds/seconds matching the HTML time scaling

    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _AuraShaderPainter oldDelegate) {
    return oldDelegate.time != time;
  }
}

class _LogoCluster extends StatefulWidget {
  const _LogoCluster();

  @override
  State<_LogoCluster> createState() => _LogoClusterState();
}

class _LogoClusterState extends State<_LogoCluster> with TickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    
    // Float Animation (6s)
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    _floatAnimation = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Pulse Animation (4s)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer Glow Pulses
        _AuraPulse(controller: _pulseController, color: const Color(0xFFCABEFF).withValues(alpha: 0.3), delay: 0.0),
        _AuraPulse(controller: _pulseController, color: const Color(0xFFC8BFFF).withValues(alpha: 0.2), delay: 0.25), // 1s delay on 4s total = 0.25
        
        // Main Glass Logo Container
        AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatAnimation.value),
              child: child,
            );
          },
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.05),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.topLeft,
                          radius: 1.5,
                          colors: [
                            const Color(0xFFCABEFF).withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 32.0),
                      child: _Visualizer(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AuraPulse extends StatelessWidget {
  final AnimationController controller;
  final Color color;
  final double delay;

  const _AuraPulse({required this.controller, required this.color, required this.delay});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double t = (controller.value + delay) % 1.0;
        
        // easeOut approximation
        double scale = 0.8 + (t * 0.7); // 0.8 to 1.5
        double opacity = 0.0;
        if (t < 0.5) {
          opacity = (t / 0.5) * 0.3; // 0 to 0.3
        } else {
          opacity = 0.3 - (((t - 0.5) / 0.5) * 0.3); // 0.3 to 0
        }

        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                boxShadow: [
                  BoxShadow(color: color, blurRadius: 40, spreadRadius: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Visualizer extends StatefulWidget {
  const _Visualizer();

  @override
  State<_Visualizer> createState() => _VisualizerState();
}

class _VisualizerState extends State<_Visualizer> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;

  final List<Duration> _durations = const [
    Duration(milliseconds: 800),
    Duration(milliseconds: 1200),
    Duration(milliseconds: 1500),
    Duration(milliseconds: 900),
    Duration(milliseconds: 1100),
    Duration(milliseconds: 1400),
    Duration(milliseconds: 1000),
  ];

  final List<Duration> _delays = const [
    Duration(milliseconds: 100),
    Duration(milliseconds: 300),
    Duration(milliseconds: 200),
    Duration(milliseconds: 400),
    Duration(milliseconds: 100),
    Duration(milliseconds: 500),
    Duration(milliseconds: 300),
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(7, (index) {
      final controller = AnimationController(
        vsync: this,
        duration: _durations[index],
      );
      
      Future.delayed(_delays[index], () {
        if (mounted) {
          controller.repeat(reverse: true);
        }
      });
      
      return controller;
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: _VisualizerBar(controller: _controllers[index]),
          );
        }),
      ),
    );
  }
}

class _VisualizerBar extends StatelessWidget {
  final AnimationController controller;

  const _VisualizerBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // height from 20% (12.8) to 80% (51.2) of 64
        final height = 12.8 + (controller.value * 38.4);
        return Container(
          width: 4,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(99),
          ),
        );
      },
    );
  }
}
