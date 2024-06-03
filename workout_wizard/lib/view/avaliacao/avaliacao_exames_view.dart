import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_wizard/controller/avaliacao_controller.dart';

class AvaliacaoExamesView extends StatefulWidget {
  const AvaliacaoExamesView({super.key});

  @override
  State<AvaliacaoExamesView> createState() => _AvaliacaoExamesViewState();
}

class _AvaliacaoExamesViewState extends State<AvaliacaoExamesView> {
  List<String> exames = [
    'Medidas corporais',
    'Dobras cutâneas',
  ];

  String docId = '';
  Map<String, dynamic>? avaliacaoData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // Recupera o docId quando o widget é inicializado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      docId = ModalRoute.of(context)!.settings.arguments as dynamic;
      fetchAvaliacaoData();
    });
  }

  void fetchAvaliacaoData() async {
    try {
      DocumentReference avaliacaoRef =
          AvaliacaoController().pegarAvaliacao(docId);
      DocumentSnapshot snapshot = await avaliacaoRef.get();
      if (snapshot.exists) {
        setState(() {
          avaliacaoData = snapshot.data() as Map<String, dynamic>?;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Documento não encontrado';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Erro ao buscar dados: $error';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        title: Text('Avaliação física'),
      ),
      backgroundColor: Colors.grey.shade100,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatDate(
                                (avaliacaoData?['data'] as Timestamp).toDate()),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            avaliacaoData != null
                                ? "IMC: ${avaliacaoData!['imc'] != null ? avaliacaoData!['imc'].toStringAsFixed(2) : ''} - ${calcularCategoriaImc(avaliacaoData!['imc'])}"
                                : "",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade400,
                                blurRadius: 5.0,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  'Exames Disponíveis',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Divider(height: 1, color: Colors.grey),
                              Expanded(
                                child: Column(
                                  children: [
                                    Card(
                                      child: ListTile(
                                        title: Text(exames[0]),
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, 'avaliacao_medidas',
                                              arguments: docId);
                                        },
                                      ),
                                    ),
                                    Card(
                                      child: ListTile(
                                        title: Text(exames[1]),
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, 'avaliacao_dobras',
                                              arguments: docId);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('d MMMM, y', 'pt_BR');
    return formatter.format(date);
  }

  String calcularCategoriaImc(double? imc) {
    if (imc != null) {
      if (imc < 18.5) {
        return "Abaixo do Peso";
      } else if (imc >= 18.5 && imc < 25) {
        return "Peso Normal";
      } else if (imc >= 25 && imc < 30) {
        return "Acima do Peso";
      } else {
        return "Obeso";
      }
    }
    return "";
  }
}
