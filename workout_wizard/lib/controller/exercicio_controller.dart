import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/exercicio.dart';
import '../view/util.dart';
import 'login_controller.dart';

class ExercicioController {
  void adicionar(context, Exercicio t) {
    FirebaseFirestore.instance
        .collection('exercicios')
        .add(t.toJson())
        .then(
            (resultado) => sucesso(context, 'Exercicio adicionado com sucesso'))
        .catchError(
            (e) => erro(context, 'Não foi possível adicionar a Exercicio'))
        .whenComplete(() => Navigator.pop(context));
  }

  //Listar todas as Exercicios do Usuário autenticado
  listar() {
    return FirebaseFirestore.instance
        .collection('Exercicios')
        .where('uid', isEqualTo: LoginController().idUsuario());
  }

  void atualizar(context, id, Exercicio t) {
    FirebaseFirestore.instance
        .collection('Exercicios')
        .doc(id)
        .update(t.toJson())
        .then(
            (resultado) => sucesso(context, 'Exercicio atualizado com sucesso'))
        .catchError(
            (e) => erro(context, 'Não foi possível atualizar o Exercicio'))
        .whenComplete(() => Navigator.pop(context));
  }

  void excluir(context, id) {
    FirebaseFirestore.instance
        .collection('Exercicios')
        .doc(id)
        .delete()
        .then((resultado) => sucesso(context, 'Exercicio excluído com sucesso'))
        .catchError(
            (e) => erro(context, 'Não foi possível excluir o Exercicio'));
  }
}
