import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_wizard/controller/login_controller.dart';
import 'package:workout_wizard/model/avaliacao.dart';
import 'package:workout_wizard/view/util.dart';

class AvaliacaoController {
  void adicionarAvaliacao(context, Avaliacao avaliacao) {
    String uid = LoginController().idUsuario();
    if (uid != null) {
      avaliacao.uid = uid; // Adiciona o UID do usuário à avaliação
      FirebaseFirestore.instance
          .collection('avaliacao')
          .add(avaliacao.toJson())
          .then((resultado) {
            sucesso(context, 'Avaliação adicionada com sucesso!');
            Navigator.pop(context);
            Navigator.pushNamed(context, 'avaliacao_exames', arguments: resultado.id);
          })
          .catchError((erro) {
            erro(context, 'Erro ao adicionar avaliação!');
          });
    } else {
      erro(context, 'Usuário não está logado.');
    }
  }

  Stream<QuerySnapshot> listarAvaliacao() {
    String uid = LoginController().idUsuario();
    if (uid != null) {
      return FirebaseFirestore.instance
          .collection('avaliacao')
          .where('uid', isEqualTo: uid)
          .snapshots();
    } else {
      throw Exception('Usuário não está logado.');
    }
  }

  DocumentReference pegarAvaliacao(String docId) {
    return FirebaseFirestore.instance.collection('avaliacao').doc(docId);
  }

  void atualizarAvaliacao(context, Avaliacao avaliacao, String docId) {
    FirebaseFirestore.instance
        .collection('avaliacao')
        .doc(docId)
        .update(avaliacao.toJson())
        .then((_) {
          sucesso(context, 'Avaliação atualizada com sucesso!');
          Navigator.pop(context);
        })
        .catchError((erro) {
          erro(context, 'Erro ao atualizar avaliação!');
        });
  }
}

