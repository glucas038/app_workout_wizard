// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercícios'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              //LoginController().logout();
              Navigator.pop(context);
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),

      // BODY
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        //
        // LISTAR as tarefas
        //
        child: StreamBuilder<QuerySnapshot>(
          //fluxo de dados
          stream: ExercicioController().listar(widget.treinoId).snapshots(),
          //exibição dos dados
          builder: (context, snapshot) {
            //verificar a conectividade
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
                  //exibir a lista de tarefas
                  return ListView.builder(
                    itemCount: dados.size,
                    itemBuilder: (context, index) {
                      //ID do documento
                      String id = dados.docs[index].id;

                      //DADOS armazenados no documento
                      dynamic item = dados.docs[index].data();

                      return Card(
                        child: ListTile(
                          title: Text(item['nm_exercicio']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Grupo Muscular: ${item['grupo_muscular']}'),
                              Text('Carga: ${item['carga'].toString()} kg'),
                              Text('Séries: ${item['series'].toString()}'),
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
                                    txtGrupoMusc.text = item['grupo_muscular'];
                                    txtCarga.text = item['carga'].toString();
                                    txtSeries.text = item['series'].toString();
                                    txtRepeticoes.text =
                                        item['repeticoes'].toString();
                                    salvarTreino(context, docId: id);
                                  },
                                  icon: Icon(Icons.edit_rounded),
                                ),
                                IconButton(
                                  onPressed: () {
                                    ExercicioController()
                                        .excluir(context, widget.treinoId, id);
                                  },
                                  icon: Icon(Icons.delete_rounded),
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
                  return Center(
                    child: Text("Nenhum treino encontrado."),
                  );
                }
            }
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          salvarTreino(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  //
  // ADICIONAR TAREFA
  //
  void salvarTreino(context, {docId}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: Text(
              (docId == null) ? "Adicionar Exercício" : "Editar Exercício"),
          content: Expanded(
            child: SizedBox(
              child: Column(
                children: [
                  TextField(
                    controller: txtNomeExercicio,
                    decoration: InputDecoration(
                      labelText: 'Nome exercício',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: txtGrupoMusc,
                    decoration: InputDecoration(
                      labelText: 'Grupo Muscular',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: txtCarga,
                    decoration: InputDecoration(
                      labelText: 'Carga',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: txtSeries,
                    decoration: InputDecoration(
                      labelText: 'Séries',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: txtRepeticoes,
                    decoration: InputDecoration(
                      labelText: 'Repetições',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
          actionsPadding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          actions: [
            TextButton(
              child: Text("fechar"),
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
              child: Text("salvar"),
              onPressed: () {
                //criação do objeto
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
