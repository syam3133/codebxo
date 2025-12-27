import 'package:dartz/dartz.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/errors/failures.dart';
import '../usecase.dart';

class SignUpUseCase implements UseCase<User, SignUpParams> {
  final AuthRepository repository;
  
  SignUpUseCase(this.repository);
  
  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    return await repository.signUp(params.email, params.password, params.name);
  }
}

class SignUpParams {
  final String email;
  final String password;
  final String name;
  
  SignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });
}