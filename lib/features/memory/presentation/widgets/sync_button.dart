import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_bloc.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_state.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_event.dart';

class SyncButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isCompact;

  const SyncButton({
    super.key,
    this.onPressed,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemoryBloc, MemoryState>(
      builder: (context, state) {
        final isSyncing = state is MemorySyncing;
        final theme = Theme.of(context);

        if (isCompact) {
          return _buildCompact(context, isSyncing, theme);
        }

        return _buildFull(context, isSyncing, theme);
      },
    );
  }

  Widget _buildFull(BuildContext context, bool isSyncing, ThemeData theme) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor,
            theme.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isSyncing ? null : (onPressed ?? () => context.read<MemoryBloc>().add(SyncMemoriesEvent())),
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSyncing)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else
                  const Icon(Icons.cloud_sync_outlined, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Text(
                  isSyncing ? 'SYNCING...' : 'BACKUP & SYNC',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompact(BuildContext context, bool isSyncing, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: isSyncing ? theme.primaryColor.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isSyncing ? theme.primaryColor : Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isSyncing ? null : (onPressed ?? () => context.read<MemoryBloc>().add(SyncMemoriesEvent())),
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSyncing)
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                    ),
                  )
                else
                  Icon(
                    Icons.sync,
                    size: 16,
                    color: theme.primaryColor,
                  ),
                const SizedBox(width: 8),
                Text(
                  isSyncing ? 'Syncing' : 'Backup',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
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
