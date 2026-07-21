import 'package:memory_ticket_app/features/auth/domain/repositories/auth_repository.dart';

class IsLoggedInUseCase {
  final AuthRepository repository;

  IsLoggedInUseCase(this.repository);

  Future<bool> call() {
    return repository.isLoggedIn();
  }
}
