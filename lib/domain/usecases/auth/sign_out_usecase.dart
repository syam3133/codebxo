import 'package:dartz/dartz.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/errors/failures.dart';
import '../usecase.dart';

class SignOutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;
  
  SignOutUseCase(this.repository);
  
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.signOut();
  }
}