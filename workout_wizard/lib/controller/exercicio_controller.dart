import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/exercicio.dart';
import '../view/util.dart';
import 'login_controller.dart';

class ExercicioController {
  void adicionar(context, Exercicio t, String treinoId) {
    FirebaseFirestore.instance
        .collection('treino')
        .doc(treinoId)
        .collection('exercicios')
        .add(t.toJson())
        .then(
            (resultado) => sucesso(context, 'Exercicio adicionado com sucesso'))
        .catchError(
            (e) => erro(context, 'Não foi possível adicionar o Exercicio'))
        .whenComplete(() => Navigator.pop(context));
  }

  // Listar todas as exercicios do Usuário autenticado dentro de um treino específico
  Query listar(String treinoId) {
    return FirebaseFirestore.instance
        .collection('treino')
        .doc(treinoId)
        .collection('exercicios')
        .where('uid', isEqualTo: LoginController().idUsuario());
  }

  void atualizar(context, String treinoId, String exercicioId, Exercicio t) {
    FirebaseFirestore.instance
        .collection('treino')
        .doc(treinoId)
        .collection('exercicios')
        .doc(exercicioId)
        .update(t.toJson())
        .then(
            (resultado) => sucesso(context, 'Exercicio atualizado com sucesso'))
        .catchError(
            (e) => erro(context, 'Não foi possível atualizar o Exercicio'))
        .whenComplete(() => Navigator.pop(context));
  }

  void excluir(context, String treinoId, String exercicioId) {
    FirebaseFirestore.instance
        .collection('treino')
        .doc(treinoId)
        .collection('exercicios')
        .doc(exercicioId)
        .delete()
        .then((resultado) => sucesso(context, 'Exercicio excluído com sucesso'))
        .catchError(
            (e) => erro(context, 'Não foi possível excluir o Exercicio'));
  }
}
