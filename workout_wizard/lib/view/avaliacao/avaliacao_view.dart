import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:workout_wizard/controller/avaliacao_controller.dart';
import 'package:workout_wizard/model/avaliacao.dart';

class AvaliacaoView extends StatefulWidget {
  const AvaliacaoView({super.key});

  @override
  State<AvaliacaoView> createState() => _AvaliacaoViewState();
}

class _AvaliacaoViewState extends State<AvaliacaoView> {
  var txtPeso = TextEditingController();
  var txtAltura = TextEditingController();
  //var txtTitulo = TextEditingController();
  //var txtDescricao = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliações físicas'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('avaliacao').snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              //sem conexão
              case ConnectionState.none:
                return Center(
                  child: Text("Falha na conexão."),
                );

              //conexão lenta
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );

              //dados recuperados com sucesso
              default:
                final dados = snapshot.requireData;
                if (dados.size > 0) {
                  final dados = snapshot.requireData;
                  //exibir a lista de avaliações
                  return ListView.builder(
                    itemCount: dados.size,
                    itemBuilder: (context, index) {
                      String docId = dados.docs[index].id;

                      //DADOS armazenados no documento
                      dynamic item = dados.docs[index].data();
                      final DateTime date =
                          (item['data'] as Timestamp).toDate();

                      return Card(
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(formatDate(date)),
                                  Text(timeDifference(date)),
                                ],
                              ),
                              Divider(), // Traço para dividir título do subtítulo
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Peso: ${item['peso']} kg'),
                                  Text('Altura: ${item['altura']} cm'),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, 'avaliacao_exames',
                                arguments: docId);
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text("Nenhuma tarefa encontrada."),
                  );
                }
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          salvarAvaliacao(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void salvarAvaliacao(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nova Avaliação'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: txtPeso,
                decoration: InputDecoration(labelText: 'Peso'),
              ),
              TextField(
                controller: txtAltura,
                decoration: InputDecoration(labelText: 'Altura'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                var avaliacao = Avaliacao(
                  peso: double.parse(txtPeso.text),
                  altura: double.parse(txtAltura.text),
                );
                //avaliacao.data = DateTime.now();
                AvaliacaoController().adicionarAvaliacao(context, avaliacao);
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

// Função para formatar a data
  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('d MMMM, y', 'pt_BR');
    return formatter.format(date);
  }

  // Função para calcular a diferença de tempo
  String timeDifference(DateTime date) {
    final Duration difference = DateTime.now().difference(date);
    if (difference.inDays < 30) {
      return '${difference.inDays} dias atrás';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} meses atrás';
    } else {
      return '${(difference.inDays / 365).floor()} anos atrás';
    }
  }
}
