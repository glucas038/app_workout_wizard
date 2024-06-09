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
      builder: (context) => const MainApp(),
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
        'avaliacao': (context) => const AvaliacaoView(),
        'avaliacao_exames': (context) => const AvaliacaoExamesView(),
        'avaliacao_dobras': (context) => const AvaliacaoDobrasCutaneasView(),
        'avaliacao_medidas': (context) => const AvaliacaoMedidasCorporaisView(),
        'login': (context) => const LoginView(),
        'treinos': (context) => const TreinosView(),
        'principal': (context) => const PrincipalView(),
        'sobre': (context) => const Sobre(),
        'cadastro': (context) => const CadastroView(),
      },
    );
  }
}
