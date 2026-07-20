import 'package:equatable/equatable.dart';
import '../../domain/entities/memory.dart';

abstract class MemoryEvent extends Equatable {
  const MemoryEvent();

  @override
  List<Object> get props => [];
}

class LoadMemories extends MemoryEvent {}

class AddMemory extends MemoryEvent {
  final Memory memory;
  const AddMemory(this.memory);

  @override
  List<Object> get props => [memory];
}

class DeleteMemoryEvent extends MemoryEvent {
  final String id;
  const DeleteMemoryEvent(this.id);

  @override
  List<Object> get props => [id];
}

class ToggleFavoriteEvent extends MemoryEvent {
  final String id;
  final bool isFavorite;
  const ToggleFavoriteEvent(this.id, this.isFavorite);

  @override
  List<Object> get props => [id, isFavorite];
}
