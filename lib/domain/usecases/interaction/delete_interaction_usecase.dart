import 'package:dartz/dartz.dart';
import '../../repositories/interaction_repository.dart';
import '../../../core/errors/failures.dart';
import '../usecase.dart';

class DeleteInteractionUseCase implements UseCase<void, String> {
  final InteractionRepository repository;
  
  DeleteInteractionUseCase(this.repository);
  
  @override
  Future<Either<Failure, void>> call(String interactionId) async {
    return await repository.deleteInteraction(interactionId);
  }
}