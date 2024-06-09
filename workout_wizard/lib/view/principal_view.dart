import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:workout_wizard/controller/login_controller.dart';

class PrincipalView extends StatelessWidget {
  const PrincipalView({Key? key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
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
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 176, 225, 231),
                    Color.fromARGB(255, 62, 139, 255),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.05),
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
                          width: screenWidth * 0.2,
                          height: screenHeight * 0.1,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: screenHeight * 0.1),
                        SizedBox(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.1,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'treinos');
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.dumbbell,
                                  size: screenWidth * 0.04,
                                  color: Colors.black,
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  'Visualizar Treinos',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenWidth * 0.04,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.1,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'avaliacao');
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: screenWidth * 0.04,
                                  color: Colors.black,
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  'Visualizar Avaliações',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenWidth * 0.04,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.1,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'sobre');
                          },
                          child: const Text(
                            "Sobre o app",
                            style: TextStyle(
                              color: Color.fromARGB(255, 64, 36, 167),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
