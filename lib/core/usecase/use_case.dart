import 'package:fpdart/fpdart.dart';
import 'package:memory_ticket_app/core/error/failure.dart';

abstract interface class UseCase<Success, Params> {
  Future<Either<Failure, Success>> call(Params params);
}
