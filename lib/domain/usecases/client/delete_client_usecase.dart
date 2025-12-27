import 'package:dartz/dartz.dart';
import '../../repositories/client_repository.dart';
import '../../../core/errors/failures.dart';
import '../usecase.dart';

class DeleteClientUseCase implements UseCase<void, String> {
  final ClientRepository repository;
  
  DeleteClientUseCase(this.repository);
  
  @override
  Future<Either<Failure, void>> call(String clientId) async {
    return await repository.deleteClient(clientId);
  }
}