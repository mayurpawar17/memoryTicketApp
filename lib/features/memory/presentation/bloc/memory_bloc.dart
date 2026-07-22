import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/memory.dart';
import '../../domain/usecases/get_memories.dart';
import '../../domain/usecases/save_memory.dart';
import '../../domain/usecases/delete_memory.dart';
import '../../domain/usecases/toggle_favorite.dart';
import 'memory_event.dart';
import 'memory_state.dart';

import 'package:memory_ticket_app/features/memory/domain/usecases/sync_memories.dart';

class MemoryBloc extends Bloc<MemoryEvent, MemoryState> {
  final GetMemories getMemories;
  final SaveMemory saveMemory;
  final DeleteMemory deleteMemory;
  final ToggleFavorite toggleFavorite;
  final SyncMemories syncMemories;

  MemoryBloc({
    required this.getMemories,
    required this.saveMemory,
    required this.deleteMemory,
    required this.toggleFavorite,
    required this.syncMemories,
  }) : super(MemoryInitial()) {
    on<LoadMemories>(_onLoadMemories);
    on<AddMemory>(_onAddMemory);
    on<DeleteMemoryEvent>(_onDeleteMemory);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<SyncMemoriesEvent>(_onSyncMemories);
  }

  Future<void> _onSyncMemories(SyncMemoriesEvent event, Emitter<MemoryState> emit) async {
    final currentState = state;
    List<Memory> currentMemories = [];
    if (currentState is MemoryLoaded) {
      currentMemories = currentState.memories;
    } else if (currentState is MemorySyncing) {
      currentMemories = currentState.memories;
    }

    emit(MemorySyncing(memories: currentMemories));
    try {
      await syncMemories();
      final memories = await getMemories();
      emit(MemoryLoaded(memories));
    } catch (e) {
      emit(MemoryError('Sync failed: ${e.toString()}'));
      // Restore previous memories if they were loaded
      if (currentMemories.isNotEmpty) {
        emit(MemoryLoaded(currentMemories));
      }
    }
  }

  Future<void> _onLoadMemories(LoadMemories event, Emitter<MemoryState> emit) async {
    emit(MemoryLoading());
    try {
      final memories = await getMemories();
      emit(MemoryLoaded(memories));
    } catch (e) {
      emit(MemoryError(e.toString()));
    }
  }

  Future<void> _onAddMemory(AddMemory event, Emitter<MemoryState> emit) async {
    try {
      await saveMemory(event.memory);
      final memories = await getMemories();
      emit(MemoryLoaded(memories));
    } catch (e) {
      emit(MemoryError(e.toString()));
    }
  }

  Future<void> _onDeleteMemory(DeleteMemoryEvent event, Emitter<MemoryState> emit) async {
    try {
      await deleteMemory(event.id);
      final memories = await getMemories();
      emit(MemoryLoaded(memories));
    } catch (e) {
      emit(MemoryError(e.toString()));
    }
  }

  Future<void> _onToggleFavorite(ToggleFavoriteEvent event, Emitter<MemoryState> emit) async {
    try {
      await toggleFavorite(event.id, event.isFavorite);
      final memories = await getMemories();
      emit(MemoryLoaded(memories));
    } catch (e) {
      emit(MemoryError(e.toString()));
    }
  }
}
