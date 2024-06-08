import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:workout_wizard/firebase_options.dart';
import 'package:workout_wizard/view/avaliacao/avaliacao_dobras_cutaneas_view.dart';
import 'package:workout_wizard/view/avaliacao/avaliacao_exames_view.dart';
import 'package:workout_wizard/view/avaliacao/avaliacao_medidas_corporais_view.dart';
import 'package:workout_wizard/view/avaliacao/avaliacao_view.dart';
import 'package:workout_wizard/view/cadastro_view.dart';
import 'package:workout_wizard/view/login_view.dart';
import 'package:workout_wizard/view/principal_view.dart';
import 'package:workout_wizard/view/sobre_view.dart';
import 'package:workout_wizard/view/treinos_view.dart';

Future<void> main() async {
  //
  // Firebase
  //
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Workout Wizard',
      initialRoute: 'login',
      routes: {
        'avaliacao': (context) => AvaliacaoView(),
        'avaliacao_exames': (context) => AvaliacaoExamesView(),
        'avaliacao_dobras': (context) => AvaliacaoDobrasCutaneasView(),
        'avaliacao_medidas': (context) => AvaliacaoMedidasCorporaisView(),
        'login': (context) => LoginView(),
        'treinos': (context) => TreinosView(),
        'principal': (context) => PrincipalView(),
        'sobre': (context) => Sobre(),
        'cadastro': (context) => CadastroView(),

      },
    );
  }
}
