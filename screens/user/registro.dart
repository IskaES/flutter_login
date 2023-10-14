import '../../providers/usuario/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/usuario/auth_provider.dart';
import '../../providers/usuario/login_provider.dart';

class RegistroScreen extends StatelessWidget {
  RegistroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          decoration: const BoxDecoration(
              // color: Colors.red.withOpacity(0.1),
              image: DecorationImage(
                  image: NetworkImage(
                      // 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShp2T_UoR8vXNZXfMhtxXPFvmDWmkUbVv3A40TYjcunag0pHFS_NMblOClDVvKLox4Atw&usqp=CAU',
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSx7IBkCtYd6ulSfLfDL-aSF3rv6UfmWYxbSE823q36sPiQNVFFLatTFdGeUSnmJ4tUzlo&usqp=CAU'),
                  fit: BoxFit.cover,
                  opacity: 0.3)),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    const Text(
                      'Registrarse',
                      style:TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                    ),
                    Text(
                      'Podras gestionar y valorar las series y mas',
                      style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.w300,
                            // height: 1.5,
                            fontSize: 15),
                    ),
    
                    const SizedBox(
                      height: 30,
                    ),
                    _RegisterForm(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¿Ya tienes cuenta?',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.go('/login');
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends ConsumerWidget {
  const _RegisterForm();

  void showSnackbar (BuildContext context, String mensaje){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje))
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // final registerForm = ref.watch(loginFormProvider);

    ref.listen(authProvider, (previus, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar (context, next.errorMessage);
    });

    return Container(
      height: 380,
      width: MediaQuery.of(context).size.width / 1.1,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 20, right: 20, bottom: 20, top: 20),
// CASILLA NOMBRE                              
            child: TextFormField(
              style: const TextStyle(color: Colors.black),
              keyboardType: TextInputType.text,
              onChanged: (value) => ref.read(registerFormProvider.notifier).onNameChange(value),
              // errorMessage: loginForm.isFormPosted ? loginForm.email.errorMessage : null,
              // controller: emailController,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        BorderRadius.all(Radius.circular(10))),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        BorderRadius.all(Radius.circular(10))),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.purple,
                ),
                filled: true,
                fillColor: Colors.white,
                labelText: "Nick",
                hintText: 'nickname',
                labelStyle: TextStyle(color: Colors.purple),
              ),
              validator: (value) {
                final validCharacters = RegExp(r'^[a-zA-Z0-9]*$');
                if (value!.isEmpty || value.length < 4 || value.length > 12) {
                  return 'El nickname debe tener entre 4 y 12 caracteres';
                } else if (!validCharacters.hasMatch(value)) {
                  return 'El nickname solo debe contener letras y números';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20, right: 20, bottom: 20, top: 20),
// CASILLA EMAIL                              
            child: TextFormField(
              style: const TextStyle(color: Colors.black),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => ref.read(registerFormProvider.notifier).onEmailChange(value),
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        BorderRadius.all(Radius.circular(10))),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        BorderRadius.all(Radius.circular(10))),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.purple,
                ),
                filled: true,
                fillColor: Colors.white,
                labelText: "Email",
                hintText: 'your-email@domain.com',
                labelStyle: TextStyle(color: Colors.purple),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Ingresa un correo';
                }
                final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Ingresa un correo electrónico válido';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Form(
// CASILLA CONTRASEÑA                            
              child: TextFormField(
                style: const TextStyle(color: Colors.black),
                onChanged: (value) => ref.read(registerFormProvider.notifier).onPasswordChanged(value),
                // controller: passwordController,
                obscuringCharacter: '*',
                obscureText: true,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius:
                          BorderRadius.all(Radius.circular(10))),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius:
                          BorderRadius.all(Radius.circular(10))),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.purple,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Contraseña",
                  hintText: '*********',
                  labelStyle: TextStyle(color: Colors.purple),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingresa una contraseña';
                  }
                
                  final uppercaseRegex = RegExp(r'[A-Z]');
                  final numberRegex = RegExp(r'[0-9]');
                
                  if (!uppercaseRegex.hasMatch(value)) {
                    return 'La contraseña debe contener al menos una letra mayúscula';
                  }
                
                  if (!numberRegex.hasMatch(value)) {
                    return 'La contraseña debe contener al menos un número';
                  }
                
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
// BOTON REGISTRO
          ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10.0)),
                      backgroundColor: const Color.fromARGB(255, 29, 107, 196),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 131, vertical: 20)
                      // padding: EdgeInsets.only(
                      //     left: 120, right: 120, top: 20, bottom: 20),
                      ),
                  onPressed: () {

                    ref.read(registerFormProvider.notifier).onFormSubmit();

                    },
                  child: const Text(
                    'Registrar',
                    style: TextStyle(fontSize: 17),
                  ))
        ],
      ),
    );
  }
}
