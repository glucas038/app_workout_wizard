import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_wizard/model/avaliacao.dart';
import 'package:workout_wizard/view/util.dart';

class AvaliacaoController {
  void adicionarAvaliacao(context, Avaliacao avaliacao) {
    FirebaseFirestore.instance
        .collection('avaliacao')
        .add(avaliacao.toJson())
        .then((resultado) =>
            sucesso(context, 'Avaliação adicionada com sucesso!'))
        .catchError((erro) => erro(context, 'Erro ao adicionar avaliação!'))
        .whenComplete(() => Navigator.pop(context));
  }

  listar() {
    return FirebaseFirestore.instance.collection('avaliacao');
  }

  listarAvaliacao(String docId) {
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
