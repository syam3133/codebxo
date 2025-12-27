import 'package:dartz/dartz.dart';
import '../../entities/client.dart';
import '../../repositories/client_repository.dart';
import '../../../core/errors/failures.dart';
import '../usecase.dart';

class AddClientUseCase implements UseCase<Client, Client> {
  final ClientRepository repository;
  
  AddClientUseCase(this.repository);
  
  @override
  Future<Either<Failure, Client>> call(Client client) async {
    return await repository.addClient(client);
  }
}