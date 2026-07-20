import 'package:fpdart/src/either.dart';
import 'package:memory_ticket_app/core/error/failure.dart';
import 'package:memory_ticket_app/core/usecase/use_case.dart';

class PickImageUseCase implements UseCase{
  @override
  Future<Either<Failure, dynamic>> call(params) {
    throw UnimplementedError();
  }
}