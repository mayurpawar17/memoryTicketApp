import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:memory_ticket_app/features/memory/presentation/pages/home_page.dart';
import 'package:memory_ticket_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemorySplashPage extends StatefulWidget {
  const MemorySplashPage({super.key});

  @override
  State<MemorySplashPage> createState() => _MemorySplashPageState();
}

class _MemorySplashPageState extends State<MemorySplashPage>
    with TickerProviderStateMixin {
  late AnimationController _bgAnimationController;
  late AnimationController _ticketAnimationController;
  late AnimationController _fadeController;

  bool _isDisposedAnimation = false;

  @override
  void initState() {
    super.initState();

    // Background dynamic canvas logic
    _bgAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // 3D Immersive Hero loop
    _ticketAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 4000,
      ), // Slightly slowed down to read content beautifully
    )..repeat();

    // Entrance animations
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _bgAnimationController.dispose();
    _ticketAnimationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _handleGetStarted() async {
    setState(() {
      _isDisposedAnimation = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final bool seenOnboarding = prefs.getBool('seen_onboarding') ?? false;

    _fadeController.reverse().then((_) {
      if (mounted) {
        if (seenOnboarding) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MemoryOnboardingPage(),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Ambient Shader Background Canvas Matrix
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bgAnimationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ShaderBackgroundPainter(
                    time: _bgAnimationController.value,
                  ),
                );
              },
            ),
          ),

          // Main Interactive Layout View
          AnimatedOpacity(
            opacity: _isDisposedAnimation ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 400),
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: _fadeController,
                curve: Curves.easeOut,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 32.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 24),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white.withOpacity(0.25),
                                width: 1.5,
                              ),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDTpJjeuHb4olVK2Y-erB2WeN82emZ90jS3GkjKEv75LCL9PeIQGczjCwwzlEhszYg9eyF5TziTvWTbEYIYpQOM4l1sSLLOQ3L-IwU8-De_jTQPUtA1xYODt7-haxm6suw-FgoHK8ceL9Tr3AHeTmB6nPnK8i4yhwp1EdGlfAM25gZ6L6Am3YTjhx697feZej2v9HyBGvlTiQMXBk9N1WT_tKOKCwTq9qv7QHQpqgyW7dGllVKbI7cy1Q',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Memory Ticket',
                            style: TextStyle(
                              fontSize: 48,
                              height: 56 / 48,
                              letterSpacing: -0.96,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF4D41DF),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Collect your moments.',
                            style: TextStyle(
                              fontSize: 18,
                              color: const Color(0xFF464555).withOpacity(0.8),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),

                      // --- 3D Immersive Responsive Hero Section (Ticket Modified) ---
                      SizedBox(
                        height: size.height * 0.42,
                        width: double.infinity,
                        child: AnimatedBuilder(
                          animation: _ticketAnimationController,
                          builder: (context, child) {
                            final double value =
                                _ticketAnimationController.value;
                            final double yAngle = value * 2 * math.pi;
                            final double xAngle =
                                math.sin(value * 2 * math.pi) * 0.15;

                            return Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(
                                  3,
                                  2,
                                  0.0015,
                                ) // Dynamic Perspective depth
                                ..rotateX(xAngle)
                                ..rotateY(yAngle),
                              child: Center(
                                child: Container(
                                  width: 200,
                                  height: 320,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF6C63FF,
                                        ).withOpacity(0.25),
                                        blurRadius: 35,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 15),
                                      ),
                                    ],
                                  ),
                                  child: ClipPath(
                                    clipper: const SplashTicketClipper(
                                      notchYRatio: 0.55,
                                    ),
                                    child: Stack(
                                      children: [
                                        // White Solid base container body
                                        Container(
                                          color: Colors.white,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              // Top Image Half Block
                                              Expanded(
                                                flex: 11,
                                                child: Image.network(
                                                  'https://images.unsplash.com/photo-1475503572774-15a45e5d60b9?w=600',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              // Bottom Meta Text Data Block
                                              Expanded(
                                                flex: 9,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                        14,
                                                        16,
                                                        14,
                                                        12,
                                                      ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Amalfi Journey',
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color(
                                                                0xFF191C1F,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 2),
                                                          Text(
                                                            'Positano, Italy',
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'OCT 2023',
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color:
                                                                  const Color(
                                                                    0xFF4D41DF,
                                                                  ).withOpacity(
                                                                    0.9,
                                                                  ),
                                                              letterSpacing:
                                                                  0.5,
                                                            ),
                                                          ),
                                                          const Icon(
                                                            Icons.qr_code,
                                                            size: 16,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Specular Overlay Gloss reflection layer
                                        Positioned.fill(
                                          child: IgnorePointer(
                                            child: CustomPaint(
                                              painter: TicketGlossPainter(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // --- Call to Action Canvas Area ---
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 64,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF6C63FF,
                                  ).withOpacity(0.25),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _handleGetStarted,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4D41DF),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: const Stack(
                                alignment: Alignment.center,
                                children: [
                                  Text(
                                    'Get Started',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Positioned(
                                    right: 24,
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.verified_user,
                                size: 14,
                                color: Color(0x99464555),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Secure Memory Encryption',
                                style: TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(
                                    0xFF464555,
                                  ).withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
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

/// Custom Clipper to create standard ticket shape punch cutouts on the side borders
class SplashTicketClipper extends CustomClipper<Path> {
  final double notchYRatio;
  const SplashTicketClipper({required this.notchYRatio});

  @override
  Path getClip(Size size) {
    final path = Path();
    const radius = 10.0;
    final notchY = size.height * notchYRatio;

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);

    // Right Notch
    path.lineTo(size.width, notchY - radius);
    path.arcToPoint(
      Offset(size.width, notchY + radius),
      radius: const Radius.circular(radius),
      clockwise: false,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    // Left Notch
    path.lineTo(0, notchY + radius);
    path.arcToPoint(
      Offset(0, notchY - radius),
      radius: const Radius.circular(radius),
      clockwise: false,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Custom Background Painter replicating the soft glowing fragment shader noise matrix
class ShaderBackgroundPainter extends CustomPainter {
  final double time;
  ShaderBackgroundPainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    const color1 = Color(0xFF6C63FF);
    const color2 = Color(0xFFFFB84D);
    const color3 = Color(0xFFF7F8FC);

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    double waveOffset = math.sin(time * 2 * math.pi * 0.1) * 0.15;

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, (0.5 + waveOffset).clamp(0.0, 1.0), 1.0],
      colors: [
        color1.withOpacity(0.85),
        Color.alphaBlend(color2.withOpacity(0.1), color3),
        color3,
      ],
    );

    paint.shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant ShaderBackgroundPainter oldDelegate) =>
      oldDelegate.time != time;
}

/// Dynamic Specular Shininess Mesh Layer for the rotating 3D Ticket frame
class TicketGlossPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.5),
          Colors.white.withOpacity(0.05),
          const Color(0xFF6C63FF).withOpacity(0.05),
          Colors.white.withOpacity(0.3),
        ],
        stops: const [0.0, 0.45, 0.55, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
