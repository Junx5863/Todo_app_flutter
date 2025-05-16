import 'package:dartz/dartz.dart';
import 'package:dash_todo_app/core/errors/failure.dart';

abstract class BaseUseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class BaseUsecaseStream<Type, Params> {
  Stream<Either<Failure, Type>> callStream(Params params);
}

class NoParams {}
