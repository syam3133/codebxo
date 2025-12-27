import 'package:dartz/dartz.dart';
import '../../entities/client.dart';
import '../../repositories/client_repository.dart';
import '../../../core/errors/failures.dart';
import '../usecase.dart';

class SearchClientsUseCase implements UseCase<List<Client>, SearchClientsParams> {
  final ClientRepository repository;
  
  SearchClientsUseCase(this.repository);
  
  @override
  Future<Either<Failure, List<Client>>> call(SearchClientsParams params) async {
    return await repository.searchClients(params.userId, params.query);
  }
}

class SearchClientsParams {
  final String userId;
  final String query;
  
  SearchClientsParams({
    required this.userId,
    required this.query,
  });
}