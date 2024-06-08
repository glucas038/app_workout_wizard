import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_wizard/controller/avaliacao_controller.dart';
import 'package:workout_wizard/controller/login_controller.dart';
import 'package:workout_wizard/model/avaliacao.dart';

class AvaliacaoView extends StatefulWidget {
  const AvaliacaoView({super.key});

  @override
  State<AvaliacaoView> createState() => _AvaliacaoViewState();
}

class _AvaliacaoViewState extends State<AvaliacaoView> {
  var txtPeso = TextEditingController();
  var txtAltura = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliações físicas'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green.shade200,
        actions: [
          IconButton(
            onPressed: () {
              LoginController().logout();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: AvaliacaoController().listarAvaliacao(),
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
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text("Nenhuma avaliação encontrada."),
                  );
                }

                final dados = snapshot.data!;
                //exibir a lista de avaliações
                return ListView.builder(
                  itemCount: dados.size,
                  itemBuilder: (context, index) {
                    String docId = dados.docs[index].id;

                    //DADOS armazenados no documento
                    dynamic item = dados.docs[index].data();
                    final DateTime date = (item['data'] as Timestamp).toDate();

                    return Card(
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Peso: ${item['peso']} kg'),
                                Text('Altura: ${item['altura']} cm'),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          print(docId);
                          Navigator.pushNamed(context, 'avaliacao_exames',
                              arguments: docId);
                        },
                      ),
                    );
                  },
                );
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
                txtAltura.clear();
                txtPeso.clear();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                double peso = double.parse(txtPeso.text);
                double altura = double.parse(txtAltura.text);

                var avaliacao = Avaliacao(
                  uid: LoginController().idUsuario()!,
                  peso: peso,
                  altura: altura,
                  data: DateTime.now(),
                  imc: (peso / (altura * altura)) *
                      10000, // Adicionando data atual
                );
                AvaliacaoController().adicionarAvaliacao(context, avaliacao);
                txtAltura.clear();
                txtPeso.clear();
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
