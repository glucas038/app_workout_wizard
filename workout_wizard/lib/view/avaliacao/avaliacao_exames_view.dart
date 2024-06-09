import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:workout_wizard/controller/avaliacao_controller.dart';
import 'package:workout_wizard/controller/avaliacao_resultado.dart';
import 'package:workout_wizard/model/resultado.dart';

class AvaliacaoExamesView extends StatefulWidget {
  const AvaliacaoExamesView({super.key});

  @override
  State<AvaliacaoExamesView> createState() => _AvaliacaoExamesViewState();
}

class _AvaliacaoExamesViewState extends State<AvaliacaoExamesView> {
  final List<String> exames = ['Medidas corporais', 'Dobras cutâneas'];
  late String avaliacaoId;
  Map<String, dynamic>? avaliacaoData;
  bool isLoading = true;
  String? errorMessage;
  Resultado? resultado;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        avaliacaoId = ModalRoute.of(context)!.settings.arguments as String;
      });
      fetchAvaliacaoData();
    });
  }

  Future<void> fetchAvaliacaoData() async {
    try {
      DocumentReference avaliacaoRef =
          AvaliacaoController().pegarAvaliacao(avaliacaoId);
      DocumentSnapshot snapshot = await avaliacaoRef.get();

      final resultadoSnapshot =
          await AvaliacaoResultadoController().listarResultado(avaliacaoId);

      if (resultadoSnapshot.docs.isNotEmpty) {
        resultado = await AvaliacaoResultadoController()
            .getResultado(resultadoSnapshot.docs.first.id, avaliacaoId);
      } else {
        resultado = Resultado.isEmpty();
        AvaliacaoResultadoController()
            .adicionarResultado(context, resultado!, avaliacaoId);
      }

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
        backgroundColor: const Color.fromARGB(255, 176, 225, 231),
        title: const Text('Avaliação física',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      backgroundColor: Colors.grey.shade100,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 10),
                      _buildComposicaoCorporalSection(),
                      const SizedBox(height: 10),
                      _buildExamesDisponiveisSection(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                FontAwesomeIcons.list,
                size: 20,
                color: Colors.black, // Cor do ícone
              ),
              const SizedBox(width: 10), // Espaçamento entre o ícone e o texto
              Text(
                formatDate((avaliacaoData?['data'] as Timestamp).toDate()),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            avaliacaoData != null
                ? "IMC: ${avaliacaoData!['imc'] != null ? avaliacaoData!['imc'].toStringAsFixed(2) : ''} - ${calcularCategoriaImc(avaliacaoData!['imc'])}"
                : "",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildComposicaoCorporalSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 5.0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream:
              AvaliacaoResultadoController().getResultadoStream(avaliacaoId),
          builder: (context, resultadoSnapshot) {
            if (resultadoSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (resultadoSnapshot.hasError) {
              return Center(
                  child: Text(
                      'Erro ao buscar resultados: ${resultadoSnapshot.error}'));
            }

            if (!resultadoSnapshot.hasData ||
                resultadoSnapshot.data!.docs.isEmpty) {
              return const Center(child: Text('Nenhum resultado encontrado'));
            }

            final resultado =
                Resultado.fromJson(resultadoSnapshot.data!.docs.first.data());

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Composição corporal',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 1, color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                  child: Row(
                    children: [
                      Expanded(
                          child: _buildComposicaoCard(
                              'Gordura Corporal',
                              '${resultado.pesoGordura.toStringAsFixed(2)} kg',
                              '${resultado.perGordura.toStringAsFixed(2)}%')),
                      const SizedBox(width: 2),
                      Expanded(
                          child: _buildComposicaoCard(
                              'Massa Magra',
                              '${resultado.pesoMagra.toStringAsFixed(2)} kg',
                              '${resultado.perMagra.toStringAsFixed(2)}%')),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: Row(
                    children: [
                      Expanded(
                          child: _buildComposicaoCard(
                              'Muscular',
                              '${resultado.pesoMuscular.toStringAsFixed(2)} kg',
                              '')),
                      const SizedBox(width: 2),
                      Expanded(
                          child: _buildComposicaoCard(
                              'Ósseo',
                              '${resultado.pesoOsseo.toStringAsFixed(2)} kg',
                              '')),
                      const SizedBox(width: 2),
                      Expanded(
                          child: _buildComposicaoCard(
                              'Residual',
                              '${resultado.pesoResidual.toStringAsFixed(2)} kg',
                              '')),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildExamesDisponiveisSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 5.0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Exames Disponíveis',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 1, color: Colors.grey),
            ...exames.map((exame) => Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  child: ListTile(
                    title: Text(exame),
                    onTap: () {
                      Navigator.pushNamed(
                          context,
                          exame == 'Medidas corporais'
                              ? 'avaliacao_medidas'
                              : 'avaliacao_dobras',
                          arguments: avaliacaoId);
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildComposicaoCard(String title, String value, String percentage) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          if (percentage.isNotEmpty)
            Text(
              percentage,
              style: const TextStyle(
                fontSize: 14,
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
        return "Sobrepeso";
      } else if (imc >= 30 && imc < 35) {
        return "Obesidade Grau I (Leve)";
      } else if (imc >= 35 && imc < 40) {
        return "Obesidade Grau II (Moderada)";
      } else {
        return "Obesidade Grau III (Mórbida)";
      }
    }
    return "";
  }
}
