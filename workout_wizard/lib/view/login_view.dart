// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';

import '../controller/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final formKey = GlobalKey<FormState>();

  var txtEmail = TextEditingController();
  var txtSenha = TextEditingController();
  var txtEmailEsqueceuSenha = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 176, 225, 231),
              Color.fromARGB(255, 62, 139, 255)
            ],
          )),
          child: Center(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final currentWidth = constraints.maxWidth;
                final currentHeight = constraints.maxHeight;

                var horizontalPadding = currentWidth * 0.03;
                var verticalPadding = currentHeight * 0.03;

                return Padding(
                  padding: EdgeInsets.fromLTRB(horizontalPadding,
                      verticalPadding, horizontalPadding, verticalPadding),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Imagens
                          Image.asset(
                            'images/ginasta-masculina-flexionando-os-bracos.png',
                            width: currentWidth * 0.25,
                            height: currentHeight * 0.15,
                            fit: BoxFit.contain,
                          ),
                          const Text.rich(TextSpan(
                              style: TextStyle(
                                fontSize: 30,
                              ),
                              children: [
                                TextSpan(
                                    text: 'Workout',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 35, 70, 228),
                                      fontWeight: FontWeight.bold,
                                    )),
                                TextSpan(
                                    text: 'Wizard',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 62, 139, 255),
                                    )),
                              ])),
                          SizedBox(height: currentHeight * 0.05),

                          // Campo de texto
                          SizedBox(
                            width: currentWidth * 0.8,
                            child: TextFormField(
                              controller: txtEmail,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                border: InputBorder.none,
                                labelText: 'E-mail',
                                labelStyle: TextStyle(color: Colors.grey),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Informe um e-mail';
                                }
                                return null;
                              },
                            ),
                          ),

                          SizedBox(height: currentHeight * 0.05),

                          SizedBox(
                            width: currentWidth * 0.8,
                            child: TextFormField(
                              controller: txtSenha,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.password),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                border: InputBorder.none,
                                labelText: 'Senha',
                                labelStyle: const TextStyle(color: Colors.grey),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Informe a senha';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: currentHeight * 0.01,
                          ),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Esqueceu a senha?"),
                                    content: Container(
                                      height: 150,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Confirme o seu email para receber um link de redefinição de senha no inbox",
                                          ),
                                          SizedBox(height: 25),
                                          TextField(
                                            controller: txtEmailEsqueceuSenha,
                                            decoration: InputDecoration(
                                              labelText: 'Email',
                                              prefixIcon: Icon(Icons.email),
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actionsPadding: EdgeInsets.all(20),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('cancelar'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          LoginController().esqueceuSenha(
                                            context,
                                            txtEmailEsqueceuSenha.text,
                                          );

                                          Navigator.pop(context);
                                        },
                                        child: Text('enviar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text("Esqueceu a senha?"),
                          ),
                          // Botões
                          SizedBox(
                            width: currentWidth < 700
                                ? currentWidth * 0.5
                                : currentWidth * 0.2,
                            height: currentHeight > 700
                                ? currentHeight * 0.04
                                : currentHeight * 0.08,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade100,
                                foregroundColor: Colors.grey.shade700,
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  LoginController().login(
                                    context,
                                    txtEmail.text,
                                    txtSenha.text,
                                  );
                                  txtEmail.clear();
                                  txtSenha.clear();
                                }
                              },
                              child: const Text('Log-in',
                                  style: TextStyle(fontSize: 20)),
                            ),
                          ),

                          SizedBox(height: currentHeight * 0.01),

                          SizedBox(
                            width: currentWidth < 700
                                ? currentWidth * 0.5
                                : currentWidth * 0.2,
                            height: currentHeight > 700
                                ? currentHeight * 0.04
                                : currentHeight * 0.08,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade100,
                                foregroundColor: Colors.grey.shade700,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, 'cadastro');
                              },
                              child: const Text('Sign-up',
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
