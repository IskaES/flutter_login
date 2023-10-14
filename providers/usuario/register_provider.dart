import 'auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class RegisterFormState {

  final bool isValid;
  final String email;
  final String password;
  final String name;

  RegisterFormState({
    this.isValid = false, 
    this.email = '', 
    this.password = '',
    this.name = '',
    });

  RegisterFormState copyWith({
    bool? isValid,
    String? email,
    String? password,
    String? name,
    }) => RegisterFormState(
      isValid: isValid ?? this.isValid,
      email: email ?? this.email,
      password: password ?? this.password, 
      name: name ?? this.name,
    );

 @override
  String toString() {
    return '''
RegisterFormState:
  isValid: $isValid
  email: $email
  password: $password
  name: $name
''';
  }
}

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {

  final Function(String, String, String ) registerUserCallback;
  RegisterFormNotifier({required this.registerUserCallback}): super(RegisterFormState());

  onNameChange (String value) {
    final newName = value;
    state = state.copyWith(
      name: newName,
      isValid: true
    );
  }

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
  // final result = 
  await registerUserCallback(state.name, state.email, state.password);

  // if (result) {
  //   // Registro o inicio de sesión exitoso, redirigir a LoginScreen o cualquier otra pantalla
  //   Navigator.of(context as BuildContext).pushReplacement(
  //     MaterialPageRoute(builder: (context) => IndexScreen()),
  //   );
  // } else {
  //   // Error en el registro o inicio de sesión, muestra un mensaje al usuario
  //   ScaffoldMessenger.of(context as BuildContext).showSnackBar(
  //     const SnackBar(
  //       content: Text('Fallo en el registro. Verifica tus credenciales.'),
  //     ),
  //   );
  // }
}
  
}

// STATE NOTIFIER PROVIDER - PARA CONSUMIR FUERA

final registerFormProvider = StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>((ref) {
  final registerUserCallback = ref.watch(authProvider.notifier).registerUser;
  return RegisterFormNotifier(registerUserCallback: registerUserCallback);
});
