import 'package:dartz/dartz.dart';
import '../../domain/entities/interaction.dart';
import '../../domain/repositories/interaction_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../datasources/interaction_remote_datasource.dart';
import '../models/interaction_model.dart';

class InteractionRepositoryImpl implements InteractionRepository {
  final InteractionRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  
  InteractionRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
  
  @override
  Future<Either<Failure, List<Interaction>>> getInteractionList(String clientId) async {
    if (await networkInfo.isConnected) {
      try {
        final interactions = await remoteDataSource.getInteractionList(clientId);
        return Right(interactions);
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
  Future<Either<Failure, Interaction>> addInteraction(Interaction interaction) async {
    if (await networkInfo.isConnected) {
      try {
        final interactionModel = InteractionModel.fromEntity(interaction);
        final addedInteraction = await remoteDataSource.addInteraction(interactionModel);
        return Right(addedInteraction);
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
  Future<Either<Failure, Interaction>> updateInteraction(Interaction interaction) async {
    if (await networkInfo.isConnected) {
      try {
        final interactionModel = InteractionModel.fromEntity(interaction);
        final updatedInteraction = await remoteDataSource.updateInteraction(interactionModel);
        return Right(updatedInteraction);
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
  Future<Either<Failure, void>> deleteInteraction(String clientId,String interactionId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteInteraction(clientId,interactionId);
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
}