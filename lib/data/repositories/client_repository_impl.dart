import 'package:dartz/dartz.dart';
import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../datasources/client_remote_datasource.dart';
import '../models/client_model.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  
  ClientRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
  
  @override
  Future<Either<Failure, List<Client>>> getClientList(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final clients = await remoteDataSource.getClientList(userId);
        return Right(clients);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, Client>> getClientById(String clientId) async {
    if (await networkInfo.isConnected) {
      try {
        final client = await remoteDataSource.getClientById(clientId);
        return Right(client);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, Client>> addClient(Client client) async {
    if (await networkInfo.isConnected) {
      try {
        final clientModel = ClientModel.fromEntity(client);
        final addedClient = await remoteDataSource.addClient(clientModel);
        return Right(addedClient);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, Client>> updateClient(Client client) async {
    if (await networkInfo.isConnected) {
      try {
        final clientModel = ClientModel.fromEntity(client);
        final updatedClient = await remoteDataSource.updateClient(clientModel);
        return Right(updatedClient);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteClient(String clientId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteClient(clientId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, List<Client>>> searchClients(String userId, String query) async {
    if (await networkInfo.isConnected) {
      try {
        final clients = await remoteDataSource.searchClients(userId, query);
        return Right(clients);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
}