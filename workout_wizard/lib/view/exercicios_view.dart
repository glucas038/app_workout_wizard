import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workout_wizard/controller/exercicio_controller.dart';
import 'package:workout_wizard/controller/login_controller.dart';
import 'package:workout_wizard/model/exercicio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExerciciosView extends StatefulWidget {
  final String treinoId;
  const ExerciciosView({super.key, required this.treinoId});

  @override
  State<ExerciciosView> createState() => _ExerciciosViewState();
}

enum OrderBy {
  nome,
  grupoMuscular,
  carga,
  series,
  repeticoes,
}

class _ExerciciosViewState extends State<ExerciciosView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController txtNomeExercicio = TextEditingController();
  final TextEditingController txtGrupoMusc = TextEditingController();
  final TextEditingController txtCarga = TextEditingController();
  final TextEditingController txtSeries = TextEditingController();
  final TextEditingController txtRepeticoes = TextEditingController();
  final TextEditingController txtPesquisa = TextEditingController();
  OrderBy _orderBy = OrderBy.nome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercícios'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
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
                ),
                const SizedBox(width: 10),
                DropdownButton<OrderBy>(
                  value: _orderBy,
                  icon: const Icon(Icons.sort),
                  onChanged: (OrderBy? newValue) {
                    setState(() {
                      _orderBy = newValue!;
                    });
                  },
                  items: OrderBy.values.map((OrderBy orderBy) {
                    String dropdownValue = '';
                    switch (orderBy) {
                      case OrderBy.nome:
                        dropdownValue = 'Nome';
                        break;
                      case OrderBy.grupoMuscular:
                        dropdownValue = 'Grupo Muscular';
                        break;
                      case OrderBy.carga:
                        dropdownValue = 'Carga';
                        break;
                      case OrderBy.series:
                        dropdownValue = 'Séries';
                        break;
                      case OrderBy.repeticoes:
                        dropdownValue = 'Repetições';
                        break;
                    }
                    return DropdownMenuItem<OrderBy>(
                      value: orderBy,
                      child: Text(dropdownValue),
                    );
                  }).toList(),
                ),
              ],
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

                        filteredDocs.sort((a, b) {
                          var itemA = a.data() as Map<String, dynamic>;
                          var itemB = b.data() as Map<String, dynamic>;
                          switch (_orderBy) {
                            case OrderBy.nome:
                              return itemA['nm_exercicio']
                                  .toString()
                                  .toLowerCase()
                                  .compareTo(itemB['nm_exercicio']
                                      .toString()
                                      .toLowerCase());
                            case OrderBy.grupoMuscular:
                              return itemA['grupo_muscular']
                                  .toString()
                                  .toLowerCase()
                                  .compareTo(itemB['grupo_muscular']
                                      .toString()
                                      .toLowerCase());
                            case OrderBy.carga:
                              return itemA['carga'].compareTo(itemB['carga']);
                            case OrderBy.series:
                              return itemA['series'].compareTo(itemB['series']);
                            case OrderBy.repeticoes:
                              return itemA['repeticoes']
                                  .compareTo(itemB['repeticoes']);
                          }
                        });

                        return ListView.builder(
                          itemCount: filteredDocs.length,
                          itemBuilder: (context, index) {
                            String id = filteredDocs[index].id;
                            dynamic item = filteredDocs[index].data();

                            return Card(
                              child: ListTile(
                                title: Text(
                                  item['nm_exercicio'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    const Text("Confirmação"),
                                                content: Text(
                                                  "Tem certeza que deseja excluir o item '${item['nm_exercicio']}'?",
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child:
                                                        const Text("Cancelar"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      ExercicioController()
                                                          .excluir(
                                                              context,
                                                              widget.treinoId,
                                                              id);
                                                    },
                                                    child:
                                                        const Text("Confirmar"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
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
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: txtNomeExercicio,
                    decoration: const InputDecoration(
                      labelText: 'Nome exercício',
                      prefixIcon: Icon(
                        FontAwesomeIcons.dumbbell,
                        size: 18,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o nome do exercício';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: txtGrupoMusc,
                    decoration: const InputDecoration(
                      labelText: 'Grupo Muscular',
                      prefixIcon: Icon(
                        FontAwesomeIcons.list,
                        size: 18,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o grupo muscular';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: txtCarga,
                    decoration: const InputDecoration(
                      labelText: 'Carga (kg)',
                      prefixIcon: Icon(
                        FontAwesomeIcons.weightScale,
                        size: 18,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o carga em kg';
                      }
                      final numericValue = int.tryParse(value);
                      if (numericValue == null) {
                        return 'Por favor, insira um número válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: txtSeries,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Séries',
                      prefixIcon: const Icon(
                        FontAwesomeIcons.listOl,
                        size: 18,
                      ),
                      border: const OutlineInputBorder(),
                      suffixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_drop_up, size: 18),
                            onPressed: () {
                              int currentValue =
                                  int.tryParse(txtSeries.text) ?? 0;
                              txtSeries.text = (currentValue + 1).toString();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_drop_down, size: 18),
                            onPressed: () {
                              int currentValue =
                                  int.tryParse(txtSeries.text) ?? 0;
                              if (currentValue > 0) {
                                txtSeries.text = (currentValue - 1).toString();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o número de séries';
                      }
                      final numericValue = int.tryParse(value);
                      if (numericValue == null) {
                        return 'Por favor, insira um número válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: txtRepeticoes,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Repetições',
                      prefixIcon: const Icon(
                        FontAwesomeIcons.rotate,
                        size: 18,
                      ),
                      border: const OutlineInputBorder(),
                      suffixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_drop_up, size: 18),
                            onPressed: () {
                              int currentValue =
                                  int.tryParse(txtRepeticoes.text) ?? 0;
                              txtRepeticoes.text =
                                  (currentValue + 1).toString();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_drop_down, size: 18),
                            onPressed: () {
                              int currentValue =
                                  int.tryParse(txtRepeticoes.text) ?? 0;
                              if (currentValue > 0) {
                                txtRepeticoes.text =
                                    (currentValue - 1).toString();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o número de repetições';
                      }
                      final numericValue = int.tryParse(value);
                      if (numericValue == null) {
                        return 'Por favor, insira um número válido';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          actions: [
            TextButton(
              child: const Text("Fechar"),
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
              child: const Text("Salvar"),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  var t = Exercicio(
                    LoginController().idUsuario(),
                    txtNomeExercicio.text,
                    txtGrupoMusc.text,
                    int.parse(txtCarga.text),
                    int.parse(txtSeries.text),
                    int.parse(txtRepeticoes.text),
                  );

                  if (docId == null) {
                    ExercicioController()
                        .adicionar(context, t, widget.treinoId);
                  } else {
                    ExercicioController()
                        .atualizar(context, widget.treinoId, docId, t);
                  }

                  txtNomeExercicio.clear();
                  txtGrupoMusc.clear();
                  txtCarga.clear();
                  txtSeries.clear();
                  txtRepeticoes.clear();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
