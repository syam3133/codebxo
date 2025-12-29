import 'package:flutter/foundation.dart';
import '../../domain/entities/client.dart';
import '../../domain/usecases/client/get_client_list_usecase.dart';
import '../../domain/usecases/client/add_client_usecase.dart';
import '../../domain/usecases/client/update_client_usecase.dart';
import '../../domain/usecases/client/delete_client_usecase.dart';
import '../../domain/usecases/client/search_clients_usecase.dart';
import '../../core/errors/failures.dart';

class ClientProvider with ChangeNotifier {
  final GetClientListUseCase getClientListUseCase;
  final AddClientUseCase addClientUseCase;
  final UpdateClientUseCase updateClientUseCase;
  final DeleteClientUseCase deleteClientUseCase;
  final SearchClientsUseCase searchClientsUseCase;
  
  ClientProvider({
    required this.getClientListUseCase,
    required this.addClientUseCase,
    required this.updateClientUseCase,
    required this.deleteClientUseCase,
    required this.searchClientsUseCase,
  });
  
  List<Client> _clients = [];
  List<Client> _filteredClients = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  
  List<Client> get clients => _filteredClients;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  
  Future<void> getClientList(String userId) async {
    _setLoading(true);
    _clearError();
    
    final result = await getClientListUseCase(userId);
    
    result.fold(
      (failure) => _setError(failure.message),
      (clients) {
        _clients = clients;
        _applyFilter();
        notifyListeners();
      },
    );
    
    _setLoading(false);
  }
  
  Future<void> addClient(Client client) async {
    _setLoading(true);
    _clearError();
    
    final result = await addClientUseCase(client);
    
    result.fold(
      (failure) => _setError(failure.message),
      (addedClient) {
        _clients.insert(0, addedClient);
        _applyFilter();
        notifyListeners();
      },
    );
    
    _setLoading(false);
  }
  
  Future<void> updateClient(Client client) async {
    _setLoading(true);
    _clearError();
    
    final result = await updateClientUseCase(client);
    
    result.fold(
      (failure) => _setError(failure.message),
      (updatedClient) {
        final index = _clients.indexWhere((c) => c.id == updatedClient.id);
        if (index != -1) {
          _clients[index] = updatedClient;
          _applyFilter();
          notifyListeners();
        }
      },
    );
    
    _setLoading(false);
  }
  
  Future<void> deleteClient(String clientId) async {
    _setLoading(true);
    _clearError();
    
    final result = await deleteClientUseCase(clientId);
    
    result.fold(
      (failure) => _setError(failure.message),
      (_) {
        _clients.removeWhere((c) => c.id == clientId);
        _applyFilter();
        notifyListeners();
      },
    );
    
    _setLoading(false);
  }
  
  Future<void> searchClients(String userId, String query) async {
    _searchQuery = query;
    _setLoading(true);
    _clearError();
    
    if (query.isEmpty) {
      _applyFilter();
      _setLoading(false);
      return;
    }
    
    final result = await searchClientsUseCase(SearchClientsParams(userId: userId, query: query));
    
    result.fold(
      (failure) => _setError(failure.message),
      (clients) {
        _filteredClients = clients;
        notifyListeners();
      },
    );
    
    _setLoading(false);
  }
  
// Add this method to getClientById if it doesn't exist in the local list:
Future<Client?> getClientById(String clientId) async {
  // First check if it's in our local list
  try {
    final client = _clients.firstWhere(
      (c) => c.id == clientId,
      orElse: () => throw Exception('Client not found'),
    );
    return client;
  } catch (e) {
    // If not found locally, return null
    return null;
  }
}
  
  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredClients = List.from(_clients);
    } else {
      _filteredClients = _clients.where((client) {
        final query = _searchQuery.toLowerCase();
        return client.clientName.toLowerCase().contains(query) ||
            (client.companyName?.toLowerCase().contains(query) ?? false) ||
            client.phoneNumber.toLowerCase().contains(query);
      }).toList();
    }
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