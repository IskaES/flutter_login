import '../../shared/services/key_value_storage_service.dart';
import '../../shared/services/key_value_storage_service_impl.dart';

import '../../domain/repositories/auth_rep.dart';
import '../../infrastructure/repositories/usuario_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user.dart';


final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {

  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthNotifier(
    authRepository: authRepository, 
    keyValueStorageService: keyValueStorageService
    );
});


class AuthNotifier extends StateNotifier<AuthState> {

  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  AuthNotifier({
    required this.authRepository, 
    required this.keyValueStorageService
    }): super(AuthState()) {
      checkAuthStatus();
    }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } catch (e) {
      logout('Credenciales no son correctas | authprovider');
    }

  }
  void registerUser(String name, String email, String password) async {
    try {
      final user = await authRepository.register(email, password, name);
      _setLoggedUser(user);
    } catch (e) {
      logout('Fallo al crear el usuario | authprovider');
    }
  }


  void checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');
    if (token == null ) return logout();
    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }

  }
  void _setLoggedUser (User user) async {
    await keyValueStorageService.setKeyValue('token', user.token);
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }
  Future<void> logout ([String? errorMessage]) async {
    await keyValueStorageService.removeKey('token');

    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage,
    );
  }
  
}

enum AuthStatus {checking, authenticated, notAuthenticated}

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking, 
    this.user, 
    this.errorMessage = '',
    });

    AuthState copyWith({
      AuthStatus? authStatus,
      User? user,
      String? errorMessage,
      }) => AuthState(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
}
