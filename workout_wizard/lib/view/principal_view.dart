import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:workout_wizard/controller/login_controller.dart';

class PrincipalView extends StatelessWidget {
  const PrincipalView({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double currentWidth = screenSize.width;
    final double currentHeight = screenSize.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 176, 225, 231),
          title: const Text('Home'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                LoginController().logout();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.keyboard_backspace_sharp),
            )
          ],
        ),
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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Bem-vindo!',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Image.asset(
                    'images/home.png',
                    width: 75,
                    height: 75,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: currentHeight * 0.1),
                  SizedBox(
                    width: currentWidth * 0.9, // 90% da largura total da tela
                    height: currentHeight * 0.1, // 30% da altura total da tela
                    child: ElevatedButton(
                      onPressed: () {
                        // Adicione a ação desejada para visualizar os treinos
                        Navigator.pushNamed(context, 'treinos');
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Borda levemente arredondada
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.dumbbell,
                            size: 18,
                            color: Colors.black, // Cor do ícone preto
                          ), // Ícone à esquerda
                          SizedBox(
                              width: 10), // Espaçamento entre o ícone e o texto
                          Text(
                            'Visualizar Treinos',
                            style: TextStyle(
                                color: Colors.black), // Cor do texto preto
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: currentWidth * 0.9, // 90% da largura total da tela
                    height: currentHeight * 0.1, // 30% da altura total da tela
                    child: ElevatedButton(
                      onPressed: () {
                        // Adicione a ação desejada para visualizar as avaliações
                        Navigator.pushNamed(context, 'avaliacao');
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Borda levemente arredondada
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.black, // Cor do ícone preto
                          ), // Ícone à esquerda
                          SizedBox(
                              width: 10), // Espaçamento entre o ícone e o texto
                          Text(
                            'Visualizar Avaliações',
                            style: TextStyle(
                                color: Colors.black), // Cor do texto preto
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: currentHeight * 0.1,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'sobre');
                    },
                    child: const Text(
                      "Sobre o app",
                      style: TextStyle(
                          color: Color.fromARGB(
                              255, 64, 36, 167)), // Cor do texto preto
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
