import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_wizard/controller/login_controller.dart';
import 'package:workout_wizard/model/medidas_corporais.dart';
import 'package:workout_wizard/view/util.dart';

class AvaliacaoMedidasController {

  // Exemplo de método para salvar as Medidas corporais no banco de dados
  void adicionarMedidas(
      context, MedidasCorporais medidas, String avaliacaoId) {
    FirebaseFirestore.instance
        .collection('avaliacao')
        .doc(avaliacaoId)
        .collection('medidas_corporais')
        .add(medidas.toJson())
        .then(
            (resultado) => sucesso(context, 'Medidas corporais adicionadas com sucesso'))
        .catchError(
            (e) => erro(context, 'Não foi possível adicionar as medidas corporais'))
        .whenComplete(() => Navigator.pop(context));
  }

  // Listar todas as medidas corporais do Usuário autenticado dentro de um treino específico
  static Future<QuerySnapshot<Map<String, dynamic>>> listarMedidas(String avaliacaoId) {
  return FirebaseFirestore.instance
      .collection('avaliacao')
      .doc(avaliacaoId)
      .collection('medidas_corporais')
      .get();
}

  void atualizarMedidas(context,MedidasCorporais medidas, String avaliacaoId, String medidasId ) {
    FirebaseFirestore.instance
        .collection('avaliacao')
        .doc(avaliacaoId)
        .collection('medidas_corporais')
        .doc(medidasId)
        .update(medidas.toJson())
        .then(
            (resultado) => sucesso(context, 'Medidas corporais atualizadas com sucesso'))
        .catchError(
            (e) => erro(context, 'Não foi possível atualizar as medidas corporais'))
        .whenComplete(() => Navigator.pop(context));
  }

  void excluirMedidas(context, String avaliacaoId, String dobrasId) {
    FirebaseFirestore.instance
        .collection('avaliacao')
        .doc(avaliacaoId)
        .collection('medidas_corporais')
        .doc(dobrasId)
        .delete()
        .then((resultado) => sucesso(context, 'Medidas corporais excluídas com sucesso'))
        .catchError(
            (e) => erro(context, 'Não foi possível excluir as medidas corporais'));
  }
  
}
