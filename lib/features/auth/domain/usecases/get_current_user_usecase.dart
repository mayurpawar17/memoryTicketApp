import 'package:memory_ticket_app/features/auth/domain/entities/user_entity.dart';
import 'package:memory_ticket_app/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<UserEntity?> call() {
    return repository.getCurrentUser();
  }
}
