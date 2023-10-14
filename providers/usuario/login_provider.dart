import 'auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import '../../screens/screens.dart';

class LoginFormState {


  final bool isValid;
  final String email;
  final String password;

  LoginFormState({
    this.isValid      = false, 
    this.email        = '', 
    this.password     = '',
    });

  LoginFormState copyWith({
    bool? isValid,
    String? email,
    String? password,
    }) => LoginFormState(
      isValid: isValid ?? this.isValid,
      email: email ?? this.email,
      password: password ?? this.password,
    );

 @override
  String toString() {
    return '''
LoginFormState:
  isValid: $isValid
  email: $email
  password: $password
''';
  }
}


class LoginFormNotifier extends StateNotifier<LoginFormState> {

  final Function(String, String ) loginUserCallback;
  LoginFormNotifier({required this.loginUserCallback}): super(LoginFormState());


  onEmailChange (String value) {
    final newEmail = value;
    state = state.copyWith(
      email: newEmail,
      isValid: true
    );
  }

  onPasswordChanged (String value) {
    final newPassword = value;
    state = state.copyWith(
      password: newPassword,
      isValid: true
    );
  }

onFormSubmit() async {
  final result = await loginUserCallback(state.email, state.password);

  if (result) {
    // Registro o inicio de sesión exitoso, redirigir a LoginScreen o cualquier otra pantalla
    Navigator.of(context as BuildContext).pushReplacement(
      MaterialPageRoute(builder: (context) => IndexScreen()),);
  } else {
    // Error en el registro o inicio de sesión, muestra un mensaje al usuario
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      const SnackBar(
        content: Text('Fallo en el registro o inicio de sesión. Verifica tus credenciales.'),
      ),
    );
  }
}
  
}

// STATE NOTIFIER PROVIDER - PARA CONSUMIR FUERA

final loginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;
  return LoginFormNotifier(loginUserCallback: loginUserCallback);
});
