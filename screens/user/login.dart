import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/usuario/auth_provider.dart';
import '../../providers/usuario/login_provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

// final AuthController _authController = AuthController();
// final TextEditingController emailController = TextEditingController();
// final TextEditingController passwordController = TextEditingController();


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
                      'Accede ahora',
                      style:TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                    ),
                    Text(
                      'Please login to continue using our app',
                      style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.w300,
                            // height: 1.5,
                            fontSize: 15),
                    ),
    
                    const SizedBox(
                      height: 30,
                    ),
                    _LoginForm(),
                    // _LoginForm(emailController: emailController, passwordController: passwordController, authController: _authController),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¿No tienes cuenta',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push('/registro'),
                          child: const Text(
                            'Registro',
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

class _LoginForm extends ConsumerWidget {
  const _LoginForm();

  // final TextEditingController emailController;
  // final TextEditingController passwordController;
  // final AuthController _authController;

  void showSnackbar (BuildContext context, String mensaje){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje))
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final loginForm = ref.watch(loginFormProvider.notifier);

    ref.listen(authProvider, (previus, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar (context, next.errorMessage);
    });

    return Container(
      height: 280,
      width: MediaQuery.of(context).size.width / 1.1,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 20, right: 20, bottom: 20, top: 20),
// CASILLA EMAIL                              
            child: TextFormField(
              style: const TextStyle(color: Colors.black),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => ref.read(loginFormProvider.notifier).onEmailChange(value),
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Form(
// CASILLA CONTRASEÑA                            
              child: TextFormField(
                style: const TextStyle(color: Colors.black),
                // controller: passwordController,
                onChanged: (value) => ref.read(loginFormProvider.notifier).onPasswordChanged(value),
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
                  if (value!.isEmpty && value.length < 4) {
                    return 'Enter a valid password';
                    
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
// BOTON ACCEDER          
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

                    ref.read(loginFormProvider.notifier).onFormSubmit();

                    },
                  child: const Text(
                    'Acceder',
                    style: TextStyle(fontSize: 17),
                  ))
        ],
      ),
    );
  }
}