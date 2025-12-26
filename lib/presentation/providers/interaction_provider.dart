import 'package:flutter/foundation.dart';
import '../../domain/entities/interaction.dart';
import '../../domain/usecases/interaction/get_interaction_list_usecase.dart';
import '../../domain/usecases/interaction/add_interaction_usecase.dart';
import '../../domain/usecases/interaction/update_interaction_usecase.dart';
import '../../domain/usecases/interaction/delete_interaction_usecase.dart';
import '../../core/errors/failures.dart';

class InteractionProvider with ChangeNotifier {
  final GetInteractionListUseCase getInteractionListUseCase;
  final AddInteractionUseCase addInteractionUseCase;
  final UpdateInteractionUseCase updateInteractionUseCase;
  final DeleteInteractionUseCase deleteInteractionUseCase;
  
  InteractionProvider({
    required this.getInteractionListUseCase,
    required this.addInteractionUseCase,
    required this.updateInteractionUseCase,
    required this.deleteInteractionUseCase,
  });
  
  List<Interaction> _interactions = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  List<Interaction> get interactions => _interactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  Future<void> getInteractionList(String clientId) async {
    _setLoading(true);
    _clearError();
    
    final result = await getInteractionListUseCase(clientId);
    
    result.fold(
      (failure) => _setError(failure.message),
      (interactions) {
        _interactions = interactions;
        notifyListeners();
      },
    );
    
    _setLoading(false);
  }
  
  Future<void> addInteraction(Interaction interaction) async {
    _setLoading(true);
    _clearError();
    
    final result = await addInteractionUseCase(interaction);
    
    result.fold(
      (failure) => _setError(failure.message),
      (addedInteraction) {
        _interactions.insert(0, addedInteraction);
        notifyListeners();
      },
    );
    
    _setLoading(false);
  }
  
  Future<void> updateInteraction(Interaction interaction) async {
    _setLoading(true);
    _clearError();
    
    final result = await updateInteractionUseCase(interaction);
    
    result.fold(
      (failure) => _setError(failure.message),
      (updatedInteraction) {
        final index = _interactions.indexWhere((i) => i.id == updatedInteraction.id);
        if (index != -1) {
          _interactions[index] = updatedInteraction;
          notifyListeners();
        }
      },
    );
    
    _setLoading(false);
  }
  
  Future<void> deleteInteraction(String interactionId) async {
    _setLoading(true);
    _clearError();
    
    final result = await deleteInteractionUseCase(interactionId);
    
    result.fold(
      (failure) => _setError(failure.message),
      (_) {
        _interactions.removeWhere((i) => i.id == interactionId);
        notifyListeners();
      },
    );
    
    _setLoading(false);
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}