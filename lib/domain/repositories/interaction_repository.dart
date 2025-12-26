import 'package:dartz/dartz.dart';
import '../entities/interaction.dart';
import '../../core/errors/failures.dart';

abstract class InteractionRepository {
  Future<Either<Failure, List<Interaction>>> getInteractionList(String clientId);
  Future<Either<Failure, Interaction>> addInteraction(Interaction interaction);
  Future<Either<Failure, Interaction>> updateInteraction(Interaction interaction);
  Future<Either<Failure, void>> deleteInteraction(String interactionId);
}