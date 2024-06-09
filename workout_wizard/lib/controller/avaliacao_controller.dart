import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_wizard/controller/login_controller.dart';
import 'package:workout_wizard/model/avaliacao.dart';
import 'package:workout_wizard/view/util.dart';

class AvaliacaoController {
  void adicionarAvaliacao(BuildContext context, Avaliacao avaliacao) {
    FirebaseFirestore.instance
        .collection('avaliacao')
        .add(avaliacao.toJson())
        .then((resultado) {
      sucesso(context, 'Avaliação adicionada com sucesso!');
      // Navigator.pop(context) será chamado dentro da função abaixo
      Navigator.pushNamed(context, 'avaliacao_exames', arguments: resultado.id)
          .then((_) {
        Navigator.pop(context); // Fechar o dialog após a navegação bem-sucedida
      });
    }).catchError((erro) {
      erro(context, 'Erro ao adicionar avaliação!');
    });
  }

  Stream<QuerySnapshot> listarAvaliacao() {
    String uid = LoginController().idUsuario();
    return FirebaseFirestore.instance
        .collection('avaliacao')
        .where('uid', isEqualTo: uid)
        .snapshots();
  }

  DocumentReference pegarAvaliacao(String docId) {
    return FirebaseFirestore.instance.collection('avaliacao').doc(docId);
  }

  Future<Avaliacao> getAvaliacao(String avaliacaoId) {
    return FirebaseFirestore.instance
        .collection('avaliacao')
        .doc(avaliacaoId)
        .get()
        .then((onValue) {
      if (onValue.exists) {
        return Avaliacao.fromJson(onValue.data() as Map<String, dynamic>);
      } else {
        throw Exception('Avaliacao não encontrado no Firestore.');
      }
    });
  }

  void atualizarAvaliacao(BuildContext context, Avaliacao avaliacao, String docId) {
    FirebaseFirestore.instance
        .collection('avaliacao')
        .doc(docId)
        .update(avaliacao.toJson())
        .then((_) {
      sucesso(context, 'Avaliação atualizada com sucesso!');
      Navigator.pop(context);
    }).catchError((erro) {
      erro(context, 'Erro ao atualizar avaliação!');
    });
  }

  void excluirAvaliacao(BuildContext context, String id) {
    FirebaseFirestore.instance
        .collection('avaliacao')
        .doc(id)
        .delete()
        .then((_) {
      sucesso(context, 'Avaliação excluída com sucesso!');
    }).catchError((erro) {
      erro(context, 'Erro ao excluir avaliação!');
    });
  }
}
