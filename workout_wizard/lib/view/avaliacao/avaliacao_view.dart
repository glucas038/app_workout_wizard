import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        title: const Text('Avaliações físicas', style: TextStyle(fontSize: 24)),
        backgroundColor: const Color.fromARGB(255, 176, 225, 231),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: AvaliacaoController().listarAvaliacao(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("Nenhuma avaliação encontrada."));
            }

            final dados = snapshot.data!;
            var filteredDocs = dados.docs;

            // Ordenação por data
            filteredDocs.sort((a, b) {
              var itemA = a.data() as Map<String, dynamic>;
              var itemB = b.data() as Map<String, dynamic>;
              return itemA['data'].compareTo(itemB['data']);
            });

            filteredDocs = filteredDocs.reversed.toList();

            return ListView.builder(
              itemCount: filteredDocs.length,
              itemBuilder: (context, index) {
                String docId = filteredDocs[index].id;
                dynamic item = filteredDocs[index].data();
                final DateTime date = (item['data'] as Timestamp).toDate();

                return _buildAvaliacaoCard(docId, item, date);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSaveAvaliacaoDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAvaliacaoCard(String docId, dynamic item, DateTime date) {
    return Card(
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDate(date)),
                Text(_timeDifference(date)),
              ],
            ),
            const Divider(), // Traço para dividir título do subtítulo
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
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            _showDeleteConfirmation(context, docId);
          },
        ),
        onTap: () {
          Navigator.pushNamed(context, 'avaliacao_exames', arguments: docId);
        },
      ),
    );
  }

  void _showSaveAvaliacaoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nova Avaliação'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: txtPeso,
                decoration: const InputDecoration(
                  labelText: 'Peso',
                  suffixText: 'kg',
                  suffixStyle: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                ],
              ),
              TextField(
                controller: txtAltura,
                decoration: const InputDecoration(
                  labelText: 'Altura',
                  suffixText: 'cm',
                  suffixStyle: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'\d')),
                ],
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
              child: const Text('Cancelar'),
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
                  imc: (peso / (altura * altura)) * 10000,
                );
                AvaliacaoController().adicionarAvaliacao(context, avaliacao);
                txtAltura.clear();
                txtPeso.clear();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _saveAvaliacao(BuildContext context) {
    double peso = double.parse(txtPeso.text);
    double altura = double.parse(txtAltura.text);

    var avaliacao = Avaliacao(
      uid: LoginController().idUsuario(),
      peso: peso,
      altura: altura,
      data: DateTime.now(),
      imc: (peso / (altura * altura)) * 10000,
    );
    AvaliacaoController().adicionarAvaliacao(context, avaliacao);
  }

  void _showDeleteConfirmation(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir Avaliação'),
          content: const Text('Tem certeza que deseja excluir esta avaliação?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                AvaliacaoController().excluirAvaliacao(context, docId);
                Navigator.pop(context);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  // Função para formatar a data
  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('d MMMM, y', 'pt_BR');
    return formatter.format(date);
  }

  // Função para calcular a diferença de tempo
  String _timeDifference(DateTime date) {
    final Duration difference = DateTime.now().difference(date);
    if (difference.inDays < 30) {
      return '${difference.inDays} dias atrás';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} meses atrás';
    } else {
      return '${(difference.inDays / 365).floor()} anos atrás';
    }
  }

  @override
  void dispose() {
    txtPeso.dispose();
    txtAltura.dispose();
    super.dispose();
  }
}
