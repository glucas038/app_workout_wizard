import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_wizard/controller/login_controller.dart';
import 'package:workout_wizard/model/avaliacao.dart';
import 'package:workout_wizard/view/util.dart';

class AvaliacaoController {
  void adicionarAvaliacao(context, Avaliacao avaliacao) {
    String docId = '';
    FirebaseFirestore.instance
        .collection('avaliacao')
        .add(avaliacao.toJson())
        .then((resultado) {
          sucesso(context, 'Avaliação adicionada com sucesso!');
          docId = resultado.id;
        })
        .catchError((erro) => erro(context, 'Erro ao adicionar avaliação!'))
        .whenComplete(() {
          Navigator.pop(context);
          Navigator.pushNamed(context, 'avaliacao_exames', arguments: docId);
        });
  }

  listarAvaliacao(String docId) {
    return FirebaseFirestore.instance
        .collection('avaliacao')
        .where('uid', isEqualTo: LoginController().idUsuario());
  }

  pegarAvaliacao(String docId) {
    return FirebaseFirestore.instance.collection('avaliacao').doc(docId);
  }

  void atualizarAvaliacao(context, Avaliacao avaliacao, String docId) {
    FirebaseFirestore.instance
        .collection('avaliacao')
        .doc(docId)
        .update(avaliacao.toJson())
        .then((resultado) =>
            sucesso(context, 'Avaliação atualizada com sucesso!'))
        .catchError((erro) => erro(context, 'Erro ao atualizar avaliação!'))
        .whenComplete(() => Navigator.pop(context));
  }
}
