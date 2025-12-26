import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/auth/sign_in_usecase.dart';
import '../../domain/usecases/auth/sign_up_usecase.dart';
import '../../domain/usecases/auth/sign_out_usecase.dart';
import '../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../core/errors/failures.dart';

class AuthProvider with ChangeNotifier {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  
  AuthProvider({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
  });
  
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  
  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    final result = await signInUseCase(SignInParams(email: email, password: password));
    
    result.fold(
      (failure) => _setError(failure.message),
      (user) {
        _user = user;
        notifyListeners();
      },
    );
    
    _setLoading(false);
  }
  
  Future<void> signUp(String email, String password, String name) async {
    _setLoading(true);
    _clearError();
    
    final result = await signUpUseCase(SignUpParams(email: email, password: password, name: name));
    
    result.fold(
      (failure) => _setError(failure.message),
      (user) {
        _user = user;
        notifyListeners();
      },
    );
    
    _setLoading(false);
  }
  
  Future<void> signOut() async {
    _setLoading(true);
    _clearError();
    
    final result = await signOutUseCase(const NoParams());
    
    result.fold(
      (failure) => _setError(failure.message),
      (_) {
        _user = null;
        notifyListeners();
      },
    );
    
    _setLoading(false);
  }
  
  Future<void> getCurrentUser() async {
    _setLoading(true);
    _clearError();
    
    final result = await getCurrentUserUseCase(const NoParams());
    
    result.fold(
      (failure) => _setError(failure.message),
      (user) {
        _user = user;
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