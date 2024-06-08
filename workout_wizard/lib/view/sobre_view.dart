import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Sobre extends StatefulWidget {
  const Sobre({super.key});

  @override
  State<Sobre> createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  final formKey = GlobalKey<FormState>();

  final txtValor1 = TextEditingController();
  final txtValor2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("Sobre o app"),
          backgroundColor: const Color.fromARGB(255, 176, 225, 231),
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
          child: Center(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final currentWidth = constraints.maxWidth;
                final currentHeight = constraints.maxHeight;

                var horizontalPadding = currentWidth * 0.005;
                var verticalPadding = currentHeight * 0.005;

                return Padding(
                  padding: EdgeInsets.fromLTRB(horizontalPadding,
                      verticalPadding, horizontalPadding, verticalPadding),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Bem-vindo ao Workout Wizard!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Image.asset(
                            'images/objetivo.png',
                            width: currentWidth * 0.15,
                            height: currentHeight * 0.15,
                            fit: BoxFit.contain,
                          ),
                          const Text(
                            "Nosso objetivo é simplificar a organização das suas atividades físicas voltadas para a musculação.",
                            textAlign: TextAlign.center,
                          ),
                          Image.asset(
                            'images/oferecer.png',
                            width: currentWidth * 0.15,
                            height: currentHeight * 0.15,
                            fit: BoxFit.contain,
                          ),
                          const Text(
                            "Oferecemos um sistema de gestão de treinos e acompanhamento de composição corporal que irão te auxiliar na progressão e nos ganhos!\n"
                            "Contamos, atualmente com dois módulos:\n"
                            "Treinos: Módulo em que a ficha de treino é desenvolvida.\n"
                            "Avaliações: Módulo em que sua avaliação está disponível para consulta.",
                            textAlign: TextAlign.center,
                          ),
                          Image.asset(
                            'images/autores.png',
                            width: currentWidth * 0.15,
                            height: currentHeight * 0.15,
                            fit: BoxFit.contain,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black),
                              children: [
                                const TextSpan(text: "Desenvolvido por "),
                                TextSpan(
                                  text: "Lucas Gabriel",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 93, 27, 168),
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      _launchURL(
                                          "https://www.linkedin.com/in/lucas-gabriel-dos-santos-pereira-54a716228/");
                                    },
                                ),
                                const TextSpan(text: " e "),
                                TextSpan(
                                  text: "Gabriel Assunção",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 93, 27, 168),
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      _launchURL(
                                          "https://www.linkedin.com/in/gabriel-assun%C3%A7%C3%A3o-96b7a3235/");
                                    },
                                ),
                              ],
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

_launchURL(String lkdUrl) async {
  final Uri url = Uri.parse(lkdUrl);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
