import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:workout_wizard/model/resultado.dart';
import 'package:workout_wizard/view/util.dart';

class AvaliacaoResultadoController extends ChangeNotifier {
  // Exemplo de método para salvar as dobras cutâneas no banco de dados
  void adicionarResultado(context, Resultado resultado, String avaliacaoId) {
    FirebaseFirestore.instance
        .collection('avaliacao')
        .doc(avaliacaoId)
        .collection('resultado')
        .add(resultado.toJson())
        .then((resultado) =>
            sucesso(context, 'Resultado adicionadas com sucesso'))
        .catchError(
            (e) => erro(context, 'Não foi possível adicionar os resultados'));
  }

  void atualizarResultado(
      context, Resultado resultado, String avaliacaoId, String resultadoId) {
    FirebaseFirestore.instance
        .collection('avaliacao')
        .doc(avaliacaoId)
        .collection('resultado')
        .doc(resultadoId)
        .update(resultado.toJson())
        .then((resultado) =>
            sucesso(context, 'Resultado atualizadas com sucesso'))
        .catchError(
            (e) => erro(context, 'Não foi possível atualizar os resultados'));
  }

  Future<Resultado> getResultado(String resultadoId, String avaliacaoId) {
    print(resultadoId);
    return FirebaseFirestore.instance
        .collection('avaliacao')
        .doc(avaliacaoId)
        .collection('resultado')
        .doc(resultadoId)
        .get()
        .then((onValue) {
      if (onValue.exists) {
        return Resultado.fromJson(onValue.data() as Map<String, dynamic>);
      } else {
        throw Exception('Resultado não encontrado no Firestore.');
      }
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getResultadoStream(String avaliacaoId) {
  return FirebaseFirestore.instance
      .collection('avaliacao')
      .doc(avaliacaoId)
      .collection('resultado')
      .snapshots();
}


  Future<QuerySnapshot<Map<String, dynamic>>> listarResultado(
      String avaliacaoId) {
    return FirebaseFirestore.instance
        .collection('avaliacao')
        .doc(avaliacaoId)
        .collection('resultado')
        .get();
  }
}
