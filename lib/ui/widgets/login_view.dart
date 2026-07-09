import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';

class LoginView extends StatefulWidget {
  final AuthProvider auth;

  const LoginView({super.key, required this.auth});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Colors from the Tailwind config
  static const Color primary = Color(0xFFCABEFF);
  static const Color onSurface = Color(0xFFE2E2E2);
  static const Color onSurfaceVariant = Color(0xFFC9C4D7);
  static const Color background = Color(0xFF121414);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isHoveringBtn = false;
  bool _isRegistering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildOrb({
    required double width,
    required double height,
    required Color color,
    required double top,
    required double left,
    required double delay,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Simple float animation logic
        final t = (_controller.value + delay) % 1.0;
        final floatY = 60 * t;
        final floatX = 40 * t;

        return Positioned(
          top: top + floatY,
          left: left + floatX,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color,
                  blurRadius: 80,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          // Background Orbs
          _buildOrb(
            width: 400,
            height: 400,
            color: const Color(0xFF4837A1).withValues(alpha: 0.4),
            top: -100,
            left: -100,
            delay: 0.0,
          ),
          _buildOrb(
            width: 350,
            height: 350,
            color: const Color(0xFF31009A).withValues(alpha: 0.4),
            top: MediaQuery.of(context).size.height - 300,
            left: MediaQuery.of(context).size.width - 200,
            delay: 0.5,
          ),
          _buildOrb(
            width: 250,
            height: 250,
            color: const Color(0xFF6043D3).withValues(alpha: 0.4),
            top: MediaQuery.of(context).size.height * 0.3,
            left: MediaQuery.of(context).size.width * 0.5,
            delay: 0.3,
          ),

          // Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Branding
                    Text(
                      'XDREW V1',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.28,
                        color: onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'By Faqih Muhamad',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vibes musik lo, mulai dari sini.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: onSurfaceVariant.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Glass Card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1)),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 32,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isRegistering ? 'Buat Akun' : 'Log in',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: onSurface,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Email Input
                              Text(
                                'ALAMAT EMAIL',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                  color: onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _emailController,
                                style: GoogleFonts.plusJakartaSans(
                                    color: onSurface, fontSize: 14),
                                decoration: InputDecoration(
                                  hintText: 'nama@aura.com',
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                      color: onSurfaceVariant.withValues(
                                          alpha: 0.4)),
                                  prefixIcon: const Icon(Icons.mail_outline,
                                      color: onSurfaceVariant),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white
                                            .withValues(alpha: 0.1)),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: primary),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Password Input
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'KATA SANDI',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.6,
                                      color: onSurfaceVariant,
                                    ),
                                  ),
                                  Text(
                                    'LUPA?',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                style: GoogleFonts.plusJakartaSans(
                                    color: onSurface, fontSize: 14),
                                decoration: InputDecoration(
                                  hintText: '••••••••',
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                      color: onSurfaceVariant.withValues(
                                          alpha: 0.4)),
                                  prefixIcon: const Icon(Icons.lock_outline,
                                      color: onSurfaceVariant),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white
                                            .withValues(alpha: 0.1)),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: primary),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Login Button
                              InkWell(
                                onTap: () async {
                                  final email = _emailController.text;
                                  final password = _passwordController.text;
                                  if (email.isEmpty || password.isEmpty) return;

                                  try {
                                    if (_isRegistering) {
                                      await widget.auth.registerWithEmail(email, password);
                                    } else {
                                      await widget.auth.loginWithEmail(email, password);
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error: ${e.toString()}')),
                                      );
                                    }
                                  }
                                },
                                onHover: (val) =>
                                    setState(() => _isHoveringBtn = val),
                                borderRadius: BorderRadius.circular(12),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: _isHoveringBtn
                                        ? primary.withValues(alpha: 0.3)
                                        : primary.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _isHoveringBtn
                                          ? primary.withValues(alpha: 0.5)
                                          : primary.withValues(alpha: 0.3),
                                    ),
                                    boxShadow: _isHoveringBtn
                                        ? [
                                            BoxShadow(
                                                color: primary.withValues(
                                                    alpha: 0.3),
                                                blurRadius: 20)
                                          ]
                                        : [],
                                  ),
                                  child: Center(
                                    child: widget.auth.isLoading
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(color: primary, strokeWidth: 2),
                                          )
                                        : Text(
                                            _isRegistering ? 'Daftar' : 'Masuk',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: primary,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Divider
                              Row(
                                children: [
                                  Expanded(
                                      child: Divider(
                                          color: Colors.white
                                              .withValues(alpha: 0.1))),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text(
                                      'ATAU LANJUTKAN DENGAN',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: onSurfaceVariant.withValues(
                                            alpha: 0.6),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Divider(
                                          color: Colors.white
                                              .withValues(alpha: 0.1))),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Social Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        try {
                                          await widget.auth.signInWithGoogle();
                                        } catch (e) {
                                          if (mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Error: ${e.toString()}')),
                                            );
                                          }
                                        }
                                      },
                                      child: _buildSocialBtn(
                                        'Google',
                                        'https://www.gstatic.com/images/branding/product/2x/googleg_48dp.png',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildSocialBtn(
                                      'Apple',
                                      'https://lh3.googleusercontent.com/aida/AP1WRLsXcOj1hBIPCicBuKqZ4-Yjag8sFTHOTD8vBgMmTYtFDi_0_qSuV-BL8m2FOpZoV_-zNlcWZbY_IzctTMaq604AcIjrnC9Eks2bNt_qoV3rj-8qkjx0vxFzqPv8Wzp9RuttVJI7A6JSo3GbvPnJEJ2qvLMbL-dGx_B8Rs6UFF_borOOnILWBEPWR1WhfEXGrcLmuxXO1Jl9Winzb6F38fMAOFncmssK07diPNK9pN2lffRXY05psE7ShT8',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),

                              // Footer Link
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isRegistering = !_isRegistering;
                                    });
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      text: _isRegistering ? 'Sudah punya akun ? ' : 'Pengguna Baru ? ',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: onSurfaceVariant,
                                        fontSize: 14,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: _isRegistering ? 'Log In' : 'Buat Akun',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: primary,
                                            fontWeight: FontWeight.bold,
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
                    ),
                    const SizedBox(height: 32),

                    // System Messages
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.verified_user_outlined,
                                color: onSurfaceVariant.withValues(alpha: 0.6),
                                size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'AKSES AMAN',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: onSurfaceVariant.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Row(
                          children: [
                            Icon(Icons.language,
                                color: onSurfaceVariant.withValues(alpha: 0.6),
                                size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'JARINGAN GLOBAL',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: onSurfaceVariant.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialBtn(String label, String iconUrl) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(iconUrl, width: 20, height: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
