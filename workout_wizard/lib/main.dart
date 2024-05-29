// ignore_for_file: prefer_const_constructors

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:workout_wizard/view/exercicios_view.dart';
import 'package:workout_wizard/view/login_view.dart';
import 'package:workout_wizard/view/treinos_view.dart';

import 'firebase_options.dart';

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
      title: 'Tarefas',
      initialRoute: 'login',
      routes: {
        'login': (context) => LoginView(), // Alterar depois
        'treinos': (context) => TreinosView(), // Alterar depois
        //'exercicios': (context) => ExerciciosView(), // Alterar depois
      },
    );
  }
}
