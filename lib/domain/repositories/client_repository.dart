import 'package:dartz/dartz.dart';
import '../entities/client.dart';
import '../../core/errors/failures.dart';

abstract class ClientRepository {
  Future<Either<Failure, List<Client>>> getClientList(String userId);
  Future<Either<Failure, Client>> getClientById(String clientId);
  Future<Either<Failure, Client>> addClient(Client client);
  Future<Either<Failure, Client>> updateClient(Client client);
  Future<Either<Failure, void>> deleteClient(String clientId);
  Future<Either<Failure, List<Client>>> searchClients(String userId, String query);
}