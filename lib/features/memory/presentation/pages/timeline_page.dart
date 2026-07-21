import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:memory_ticket_app/core/colors/app_theme.dart';
import 'package:memory_ticket_app/features/memory/domain/entities/memory.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_bloc.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_event.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_state.dart';
import 'package:memory_ticket_app/features/memory/presentation/pages/memory_ticket_details_page.dart';
import 'package:memory_ticket_app/features/memory/presentation/pages/new_memory_ticket_page.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: BlocBuilder<MemoryBloc, MemoryState>(
        builder: (context, state) {
          if (state is MemoryLoading) {
            return _buildLoadingState();
          } else if (state is MemoryError) {
            return _buildErrorState(context, state.message);
          } else if (state is MemoryLoaded) {
            if (state.memories.isEmpty) {
              return _buildEmptyState(context);
            }
            return _TimelineContent(memories: state.memories);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppTheme.primary,
        strokeWidth: 3,
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
          const SizedBox(height: 16),
          const Text(
            "Couldn't load timeline",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(message, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<MemoryBloc>().add(LoadMemories()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Retry"),
          ),
        ],
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
                size: 80, color: AppTheme.primary.withOpacity(0.2)),
            const SizedBox(height: 24),
            const Text(
              "No memories yet",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Start capturing moments to build your life timeline.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
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
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 4,
                shadowColor: AppTheme.primary.withOpacity(0.4),
              ),
              child: const Text("Create Memory"),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineContent extends StatelessWidget {
  final List<Memory> memories;

  const _TimelineContent({required this.memories});

  @override
  Widget build(BuildContext context) {
    final grouped = _groupMemories(memories);
    final onThisDay = _getOnThisDay(memories);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildAppBar(),
        if (onThisDay.isNotEmpty)
          SliverToBoxAdapter(
              child: _buildOnThisDaySection(context, onThisDay.first)),
        ..._buildTimelineSlivers(context, grouped),
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      backgroundColor: AppTheme.bgLight,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 1.2,
        titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Timeline",
              style: TextStyle(
                color: AppTheme.textDark,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Text(
              "Relive your life's journey",
              style: TextStyle(
                color: AppTheme.subtitleDark,
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnThisDaySection(BuildContext context, Memory memory) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "✨ On This Day",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
            "One year ago today",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 16),
          TimelineMemoryCard(
            memory: memory,
            onTap: () => _navigateToDetails(context, memory),
          ),
          const SizedBox(height: 16),
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),
        ],
      ),
    );
  }

  List<Widget> _buildTimelineSlivers(
      BuildContext context, Map<int, Map<int, List<Memory>>> grouped) {
    List<Widget> slivers = [];

    grouped.forEach((year, months) {
      int yearCount = 0;
      for (var m in months.values) {
        yearCount += m.length;
      }

      slivers.add(
        SliverPersistentHeader(
          pinned: true,
          delegate: _TimelineHeaderDelegate(
            title: year.toString(),
            subtitle: "$yearCount Memories",
            isYear: true,
          ),
        ),
      );

      months.forEach((month, memoriesInMonth) {
        slivers.add(
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: Text(
                DateFormat('MMMM').format(DateTime(0, month)).toUpperCase(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.subtitleDark,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        );

        slivers.add(
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final memory = memoriesInMonth[index];
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTimelineIndicator(index, memoriesInMonth.length),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TimelineMemoryCard(
                            memory: memory,
                            onTap: () => _navigateToDetails(context, memory),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: memoriesInMonth.length,
              ),
            ),
          ),
        );
      });
    });

    return slivers;
  }

  Widget _buildTimelineIndicator(int index, int total) {
    return SizedBox(
      width: 24,
      child: Column(
        children: [
          Container(
            width: 2,
            height: 24,
            color: index == 0 ? Colors.transparent : Colors.grey[300],
          ),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: 2,
              color: index == total - 1 ? Colors.transparent : Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetails(BuildContext context, Memory memory) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MemoryTicketDetailsScreen(memory: memory),
      ),
    );
  }

  Map<int, Map<int, List<Memory>>> _groupMemories(List<Memory> memories) {
    final groups = <int, Map<int, List<Memory>>>{};
    for (var memory in memories) {
      try {
        final date = DateFormat('MMM dd yyyy').parse(memory.date);
        groups.putIfAbsent(date.year, () => {});
        groups[date.year]!.putIfAbsent(date.month, () => []);
        groups[date.year]![date.month]!.add(memory);
      } catch (e) {
        // Silently skip unparseable dates
      }
    }

    final sortedYears = groups.keys.toList()..sort((a, b) => b.compareTo(a));
    final sortedGroups = <int, Map<int, List<Memory>>>{};
    for (var year in sortedYears) {
      final months = groups[year]!;
      final sortedMonths = months.keys.toList()..sort((a, b) => b.compareTo(a));
      final sortedMonthsMap = <int, List<Memory>>{};
      for (var month in sortedMonths) {
        final memoriesInMonth = months[month]!;
        memoriesInMonth.sort((a, b) {
          try {
            final dateA = DateFormat('MMM dd yyyy').parse(a.date);
            final dateB = DateFormat('MMM dd yyyy').parse(b.date);
            return dateB.compareTo(dateA);
          } catch (e) {
            return 0;
          }
        });
        sortedMonthsMap[month] = memoriesInMonth;
      }
      sortedGroups[year] = sortedMonthsMap;
    }
    return sortedGroups;
  }

  List<Memory> _getOnThisDay(List<Memory> memories) {
    final now = DateTime.now();
    return memories.where((m) {
      try {
        final date = DateFormat('MMM dd yyyy').parse(m.date);
        return date.month == now.month &&
            date.day == now.day &&
            date.year < now.year;
      } catch (e) {
        return false;
      }
    }).toList();
  }
}

class _TimelineHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final String subtitle;
  final bool isYear;

  _TimelineHeaderDelegate(
      {required this.title, required this.subtitle, this.isYear = false});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppTheme.bgLight.withOpacity(0.95),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isYear ? 32 : 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
              letterSpacing: -1,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.subtitleDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 84;
  @override
  double get minExtent => 84;
  @override
  bool shouldRebuild(covariant _TimelineHeaderDelegate oldDelegate) {
    return oldDelegate.title != title || oldDelegate.subtitle != subtitle;
  }
}

class TimelineMemoryCard extends StatelessWidget {
  final Memory memory;
  final VoidCallback onTap;

  const TimelineMemoryCard({super.key, required this.memory, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'memory_image_${memory.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: _buildImage(memory.imagePath),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          memory.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Text("✨", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        memory.location,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.calendar_today_outlined,
                          size: 13, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        memory.date,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    memory.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppTheme.textDark.withOpacity(0.7),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        memory.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: memory.isFavorite ? Colors.redAccent : Colors.grey[400],
                        size: 20,
                      ),
                      Icon(Icons.more_horiz_rounded, color: Colors.grey[400]),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    final bool isNetwork = imagePath.startsWith('http');

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 180,
      ),
      child: isNetwork
          ? CachedNetworkImage(
              imageUrl: imagePath,
              fit: BoxFit.contain,
              width: double.infinity,
              fadeInDuration: const Duration(milliseconds: 500),
              fadeOutDuration: const Duration(milliseconds: 300),
              placeholder: (context, url) => Container(
                color: Colors.grey[50],
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black12,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[50],
                width: double.infinity,
                alignment: Alignment.center,
                child: const Icon(Icons.error_outline,
                    size: 20, color: Colors.black26),
              ),
            )
          : imagePath.isNotEmpty
              ? Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                  width: double.infinity,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) return child;
                    return AnimatedOpacity(
                      opacity: frame == null ? 0 : 1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      child: child,
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[100],
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_not_supported_outlined,
                        color: Colors.grey),
                  ),
                )
              : Container(
                  color: Colors.grey[100],
                  alignment: Alignment.center,
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
    );
  }
}
