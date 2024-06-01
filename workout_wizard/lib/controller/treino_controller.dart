import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/treino.dart';
import '../view/util.dart';
import 'login_controller.dart';

class TreinoController {
  void adicionar(context, Treino t) {
    FirebaseFirestore.instance
        .collection('treino')
        .add(t.toJson())
        .then((resultado) => sucesso(context, 'Treino adicionado com sucesso'))
        .catchError((e) => erro(context, 'Não foi possível adicionar a Treino'))
        .whenComplete(() => Navigator.pop(context));
  }

  //Listar todas as Treinos do Usuário autenticado
  listar() {
    return FirebaseFirestore.instance
        .collection('treino')
        .where('uid', isEqualTo: LoginController().idUsuario());
  }

  void atualizar(context, id, Treino t) {
    FirebaseFirestore.instance
        .collection('treino')
        .doc(id)
        .update(t.toJson())
        .then((resultado) => sucesso(context, 'Treino atualizado com sucesso'))
        .catchError((e) => erro(context, 'Não foi possível atualizar o Treino'))
        .whenComplete(() => Navigator.pop(context));
  }

  void excluir(context, id) {
    FirebaseFirestore.instance
        .collection('treino')
        .doc(id)
        .delete()
        .then((resultado) => sucesso(context, 'Treino excluído com sucesso'))
        .catchError((e) => erro(context, 'Não foi possível excluir o Treino'));
  }
}
