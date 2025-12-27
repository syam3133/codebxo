import 'package:dartz/dartz.dart';
import '../../entities/client.dart';
import '../../repositories/client_repository.dart';
import '../../../core/errors/failures.dart';
import '../usecase.dart';

class GetClientListUseCase implements UseCase<List<Client>, String> {
  final ClientRepository repository;
  
  GetClientListUseCase(this.repository);
  
  @override
  Future<Either<Failure, List<Client>>> call(String userId) async {
    return await repository.getClientList(userId);
  }
}