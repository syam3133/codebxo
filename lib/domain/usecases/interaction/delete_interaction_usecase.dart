import 'package:dartz/dartz.dart';
import 'package:field_sales_crm/domain/usecases/usecasenew.dart';
import '../../entities/interaction.dart';
import '../../repositories/interaction_repository.dart';
import '../../../core/errors/failures.dart';


class DeleteInteractionUseCase implements UseCaseNew<void, String,String> {
  final InteractionRepository repository;
  
  DeleteInteractionUseCase(this.repository);
  
  @override
  Future<Either<Failure, void>> call(String clientId,String interactionId) async {
    return await repository.deleteInteraction(clientId,interactionId);
  }
}



class DeleteInteractionParams {
  final String clientId;
  final String interactionId;

  const DeleteInteractionParams({
    required this.clientId,
    required this.interactionId,
  });
}