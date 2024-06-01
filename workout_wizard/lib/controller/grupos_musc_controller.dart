import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/exercicio.dart';
import '../view/util.dart';
import 'login_controller.dart';

class GruposMuscularesController {
  // Listar todas as exercicios do Usuário autenticado dentro de um treino específico
  CollectionReference<Map<String, dynamic>> listar() {
    return FirebaseFirestore.instance.collection('gruposMusculares');
  }
}
