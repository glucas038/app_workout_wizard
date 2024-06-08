import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_wizard/model/dobras_cutaneas.dart';
import 'package:workout_wizard/view/util.dart';

class AvaliacaoDobrasController extends ChangeNotifier {
  // Adicione aqui as propriedades e métodos necessários para o cálculo das dobras cutâneas

  // Exemplo de propriedade para armazenar o valor da dobra cutânea
  double dobraCutanea = 0;

  // Exemplo de método para calcular a média das dobras cutâneas
  void calcularMediaDobrasCutaneas(List<double> dobras) {
    double somaDobras = 0;
    for (double dobra in dobras) {
      somaDobras += dobra;
    }
    dobraCutanea = somaDobras / dobras.length;
    notifyListeners();
  }

  // Exemplo de método para salvar as dobras cutâneas no banco de dados
  void adicionarDobras(
      context, DobrasCutaneas dobras, String avaliacaoId) {
    FirebaseFirestore.instance
        .collection('avaliacao')
        .doc(avaliacaoId)
        .collection('dobras_cutaneas')
        .add(dobras.toJson())
        .then(
            (resultado) => sucesso(context, 'Dobras cutâneas adicionadas com sucesso'))
        .catchError(
            (e) => erro(context, 'Não foi possível adicionar as dobras cutâneas'))
        .whenComplete(() => Navigator.pop(context));
  }

  // Listar todas as exercicios do Usuário autenticado dentro de um treino específico
  static Future<QuerySnapshot<Map<String, dynamic>>> listarDobras(String avaliacaoId) {
  return FirebaseFirestore.instance
      .collection('avaliacao')
      .doc(avaliacaoId)
      .collection('dobras_cutaneas')
      .get();
}

  void atualizarDobras(context, DobrasCutaneas dobras, String avaliacaoId, String dobrasId) {
    FirebaseFirestore.instance
        .collection('avaliacao')
        .doc(avaliacaoId)
        .collection('dobras_cutaneas')
        .doc(dobrasId)
        .update(dobras.toJson())
        .then(
            (resultado) => sucesso(context, 'Dobras cutâneas atualizadas com sucesso'))
        .catchError(
            (e) => erro(context, 'Não foi possível atualizar as dobras cutâneas'))
        .whenComplete(() => Navigator.pop(context));
  }

  void excluirDobras(context, String avaliacaoId, String dobrasId) {
    FirebaseFirestore.instance
        .collection('avaliacao')
        .doc(avaliacaoId)
        .collection('dobras_cutaneas')
        .doc(dobrasId)
        .delete()
        .then((resultado) => sucesso(context, 'Dobras cutâneas excluídas com sucesso'))
        .catchError(
            (e) => erro(context, 'Não foi possível excluir as dobras cutâneas'));
  }
}
