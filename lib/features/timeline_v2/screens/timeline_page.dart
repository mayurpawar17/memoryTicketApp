import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/colors/app_colors.dart';
import '../../memory/presentation/bloc/memory_bloc.dart';
import '../../memory/presentation/bloc/memory_state.dart';
import '../../memory/presentation/pages/new_memory_ticket_page.dart';
import '../painters/timeline_painter.dart';
import '../widgets/timeline_item.dart';

class TimelinePage2 extends StatefulWidget {
  const TimelinePage2({super.key});

  @override
  State<TimelinePage2> createState() => _TimelinePage2State();
}

class _TimelinePage2State extends State<TimelinePage2> with TickerProviderStateMixin {
  late AnimationController _scrollController;
  late AnimationController _pathController;

  @override
  void initState() {
    super.initState();
    _pathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    
    _scrollController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _pathController.forward();
    _scrollController.forward();
  }

  @override
  void dispose() {
    _pathController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<MemoryBloc, MemoryState>(
        builder: (context, state) {
          if (state is MemoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MemoryError) {
            return Center(child: Text(state.message));
          } else if (state is MemoryLoaded) {
            final memories = state.memories;
            if (memories.isEmpty) {
              return _buildEmptyState(context);
            }

            return Stack(
              children: [
                const NoiseBackground(),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: IntrinsicHeight(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: RepaintBoundary(
                            child: AnimatedBuilder(
                              animation: _pathController,
                              builder: (context, child) {
                                return CustomPaint(
                                  painter: TimelinePainter(
                                    progress: _pathController.value,
                                    color: AppColors.primary,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SafeArea(
                          child: Column(
                            children: [
                              const SizedBox(height: 60),
                              Text(
                                'YOUR MEMORIES',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                  letterSpacing: 4,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Life\'s Timeline',
                                style: GoogleFonts.poppins(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 100),
                              ...List.generate(memories.length, (index) {
                                final animation = CurvedAnimation(
                                  parent: _scrollController,
                                  curve: Interval(
                                    (index / memories.length) * 0.5,
                                    ((index + 1) / memories.length).clamp(0, 1),
                                    curve: Curves.easeOutCubic,
                                  ),
                                );
                                return TimelineItem(
                                  memory: memories[index],
                                  index: index,
                                  animation: animation,
                                );
                              }),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_stories_outlined,
                size: 80, color: AppColors.primary.withOpacity(0.2)),
            const SizedBox(height: 24),
            Text(
              "No memories yet",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Start capturing moments to build your life timeline.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NewMemoryTicketPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 4,
                shadowColor: AppColors.primary.withOpacity(0.4),
              ),
              child: const Text("Create Memory"),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Go Back", style: TextStyle(color: AppColors.textSecondary)),
            ),
          ],
        ),
      ),
    );
  }
}

class NoiseBackground extends StatelessWidget {
  const NoiseBackground({super.key});

  @override
  Widget build(BuildContext context) {
    // Note: Using a container with subtle noise color if asset noise isn't available
    return Positioned.fill(
      child: Container(
        color: Colors.transparent,
        // In a real app, you'd use a noise texture image here
      ),
    );
  }
}
