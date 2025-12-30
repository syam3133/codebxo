import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';

abstract class UseCaseNew<Type, Params,Params2> {
  Future<Either<Failure, Type>> call(Params params,Params params2);
}

class NoParams {}