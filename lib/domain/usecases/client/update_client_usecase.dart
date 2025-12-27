import 'package:dartz/dartz.dart';
import '../../entities/client.dart';
import '../../repositories/client_repository.dart';
import '../../../core/errors/failures.dart';
import '../usecase.dart';

class UpdateClientUseCase implements UseCase<Client, Client> {
  final ClientRepository repository;
  
  UpdateClientUseCase(this.repository);
  
  @override
  Future<Either<Failure, Client>> call(Client client) async {
    return await repository.updateClient(client);
  }
}