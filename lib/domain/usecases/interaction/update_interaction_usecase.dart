import 'package:dartz/dartz.dart';
import '../../entities/interaction.dart';
import '../../repositories/interaction_repository.dart';
import '../../../core/errors/failures.dart';
import '../usecase.dart';

class UpdateInteractionUseCase implements UseCase<Interaction, Interaction> {
  final InteractionRepository repository;
  
  UpdateInteractionUseCase(this.repository);
  
  @override
  Future<Either<Failure, Interaction>> call(Interaction interaction) async {
    return await repository.updateInteraction(interaction);
  }
}