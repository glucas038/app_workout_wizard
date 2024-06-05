// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_wizard/view/exercicios_view.dart';

import '../controller/login_controller.dart';
import '../controller/treino_controller.dart';
import '../model/treino.dart';

class TreinosView extends StatefulWidget {
  const TreinosView({super.key});

  @override
  State<TreinosView> createState() => _TreinosViewState();
}

class _TreinosViewState extends State<TreinosView> {
  var txtTreino = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treinos'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              LoginController().logout();
              Navigator.pop(context);
            },
            icon: Icon(Icons.keyboard_backspace_sharp),
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
          stream: TreinoController().listar().snapshots(),
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
                          title: Text(item['ds_treino']),
                          //
                          // Atualizar e Excluir Tarefas
                          //
                          trailing: SizedBox(
                            width: 80,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    txtTreino.text = item['ds_treino'];
                                    salvarTreino(context, docId: id);
                                  },
                                  icon: Icon(Icons.edit_rounded),
                                ),
                                IconButton(
                                  onPressed: () {
                                    TreinoController().excluir(context, id);
                                  },
                                  icon: Icon(Icons.delete_rounded),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ExerciciosView(treinoId: id),
                              ),
                            );
                          },
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
          title: Text((docId == null) ? "Adicionar Treino" : "Editar Treino"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: txtTreino,
                  decoration: InputDecoration(
                    labelText: 'Desc. Treino',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
          actionsPadding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          actions: [
            TextButton(
              child: Text("fechar"),
              onPressed: () {
                txtTreino.clear();
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("salvar"),
              onPressed: () {
                //criação do objeto
                var t = Treino(
                  LoginController().idUsuario(),
                  txtTreino.text,
                );

                if (docId == null) {
                  TreinoController().adicionar(context, t);
                } else {
                  TreinoController().atualizar(context, docId, t);
                }

                txtTreino.clear();
              },
            ),
          ],
        );
      },
    );
  }
}
