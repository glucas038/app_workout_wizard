import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_wizard/controller/exercicio_controller.dart';
import 'package:workout_wizard/model/exercicio.dart';
import '../controller/login_controller.dart';

class ExerciciosView extends StatefulWidget {
  final String treinoId;
  const ExerciciosView({super.key, required this.treinoId});

  @override
  State<ExerciciosView> createState() => _ExerciciosViewState();
}

class _ExerciciosViewState extends State<ExerciciosView> {
  var txtNomeExercicio = TextEditingController();
  var txtGrupoMusc = TextEditingController();
  var txtCarga = TextEditingController();
  var txtSeries = TextEditingController();
  var txtRepeticoes = TextEditingController();
  var txtPesquisa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercícios'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              //LoginController().logout();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),

      // BODY
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: txtPesquisa,
              decoration: const InputDecoration(
                labelText: 'Pesquisar',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    ExercicioController().listar(widget.treinoId).snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return const Center(child: Text("Falha na conexão."));
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    default:
                      final dados = snapshot.requireData;
                      if (dados.size > 0) {
                        var filteredDocs = dados.docs.where((doc) {
                          var item = doc.data() as Map<String, dynamic>;
                          var searchText = txtPesquisa.text.toLowerCase();
                          return item['nm_exercicio']
                              .toString()
                              .toLowerCase()
                              .contains(searchText);
                        }).toList();

                        return ListView.builder(
                          itemCount: filteredDocs.length,
                          itemBuilder: (context, index) {
                            String id = filteredDocs[index].id;
                            dynamic item = filteredDocs[index].data();

                            return Card(
                              child: ListTile(
                                title: Text(item['nm_exercicio']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Grupo Muscular: ${item['grupo_muscular']}'),
                                    Text(
                                        'Carga: ${item['carga'].toString()} kg'),
                                    Text(
                                        'Séries: ${item['series'].toString()}'),
                                    Text(
                                        'Repetições: ${item['repeticoes'].toString()}'),
                                  ],
                                ),
                                trailing: SizedBox(
                                  width: 80,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          txtNomeExercicio.text =
                                              item['nm_exercicio'];
                                          txtGrupoMusc.text =
                                              item['grupo_muscular'];
                                          txtCarga.text =
                                              item['carga'].toString();
                                          txtSeries.text =
                                              item['series'].toString();
                                          txtRepeticoes.text =
                                              item['repeticoes'].toString();
                                          salvarTreino(context, docId: id);
                                        },
                                        icon: const Icon(Icons.edit_rounded),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          ExercicioController().excluir(
                                              context, widget.treinoId, id);
                                        },
                                        icon: const Icon(Icons.delete_rounded),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {},
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                            child: Text("Nenhum exercício encontrado."));
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          salvarTreino(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void salvarTreino(context, {docId}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              (docId == null) ? "Adicionar Exercício" : "Editar Exercício"),
          content: Expanded(
            child: SizedBox(
              child: Column(
                children: [
                  TextField(
                    controller: txtNomeExercicio,
                    decoration: const InputDecoration(
                      labelText: 'Nome exercício',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: txtGrupoMusc,
                    decoration: const InputDecoration(
                      labelText: 'Grupo Muscular',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: txtCarga,
                    decoration: const InputDecoration(
                      labelText: 'Carga',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: txtSeries,
                    decoration: const InputDecoration(
                      labelText: 'Séries',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: txtRepeticoes,
                    decoration: const InputDecoration(
                      labelText: 'Repetições',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          actions: [
            TextButton(
              child: const Text("fechar"),
              onPressed: () {
                txtNomeExercicio.clear();
                txtGrupoMusc.clear();
                txtCarga.clear();
                txtSeries.clear();
                txtRepeticoes.clear();
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("salvar"),
              onPressed: () {
                var t = Exercicio(
                    LoginController().idUsuario(),
                    txtNomeExercicio.text,
                    txtGrupoMusc.text,
                    int.parse(txtCarga.text),
                    int.parse(txtSeries.text),
                    int.parse(txtRepeticoes.text));

                if (docId == null) {
                  ExercicioController().adicionar(context, t, widget.treinoId);
                } else {
                  ExercicioController()
                      .atualizar(context, widget.treinoId, docId, t);
                }

                txtNomeExercicio.clear();
                txtGrupoMusc.clear();
                txtCarga.clear();
                txtSeries.clear();
                txtRepeticoes.clear();
              },
            ),
          ],
        );
      },
    );
  }
}
