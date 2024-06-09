import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_wizard/controller/avaliacao_controller.dart';
import 'package:workout_wizard/controller/avaliacao_dobras_controller.dart';
import 'package:workout_wizard/controller/avaliacao_resultado.dart';
import 'package:workout_wizard/controller/login_controller.dart';
import 'package:workout_wizard/model/dobras_cutaneas.dart';
import 'package:workout_wizard/model/resultado.dart';
import 'package:workout_wizard/view/util.dart';

class AvaliacaoDobrasCutaneasView extends StatefulWidget {
  const AvaliacaoDobrasCutaneasView({super.key});

  @override
  _AvaliacaoDobrasCutaneasViewState createState() =>
      _AvaliacaoDobrasCutaneasViewState();
}

class _AvaliacaoDobrasCutaneasViewState
    extends State<AvaliacaoDobrasCutaneasView> {
  final _formKey = GlobalKey<FormState>();
  final List<String> labels = [
    'Tríceps',
    'Peitoral',
    'Axilar Média',
    'Subescapular',
    'Supra-ilíaca',
    'Abdominal',
    'Coxa',
  ];
  final List<TextEditingController> controllers =
      List.generate(7, (_) => TextEditingController());

  bool isLoading = true;
  String? errorMessage;
  String? avaliacaoId;
  bool isEditing = false;
  String? dobrasId;
  String? resultadoId;
  bool isSaving = false; // Para o feedback de salvamento

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      avaliacaoId = ModalRoute.of(context)!.settings.arguments as String;
      fetchDobrasCutaneas();
    });
  }

  Future<void> fetchDobrasCutaneas() async {
    try {
      if (avaliacaoId != null) {
        final dobrasSnapshot =
            await AvaliacaoDobrasController.listarDobras(avaliacaoId!);
        final resultadoSnapshot = await AvaliacaoResultadoController()
            .getResultadoStream(avaliacaoId!)
            .first;
        resultadoId = resultadoSnapshot.docs.first.id;

        if (dobrasSnapshot.docs.isNotEmpty) {
          isEditing = true;
          dobrasId = dobrasSnapshot.docs.first.id;
          final dobrasData =
              dobrasSnapshot.docs.first.data() as Map<String, dynamic>;

          if (dobrasData != null) {
            final dobrasCutaneas = DobrasCutaneas.fromJson(dobrasData);
            setState(() {
              for (int i = 0; i < labels.length; i++) {
                controllers[i].text =
                    getValueByLabel(labels[i], dobrasCutaneas) != '0'
                        ? getValueByLabel(labels[i], dobrasCutaneas)
                        : '';
              }
              isLoading = false;
            });
          }
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Erro ao buscar dados: $error';
        isLoading = false;
      });
    }
  }

  String getValueByLabel(String label, DobrasCutaneas dobrasCutaneas) {
    switch (label) {
      case 'Tríceps':
        return dobrasCutaneas.triceps.toString();
      case 'Peitoral':
        return dobrasCutaneas.peitoral.toString();
      case 'Axilar Média':
        return dobrasCutaneas.axilarMedia.toString();
      case 'Subescapular':
        return dobrasCutaneas.subescapular.toString();
      case 'Supra-ilíaca':
        return dobrasCutaneas.supraIliaca.toString();
      case 'Abdominal':
        return dobrasCutaneas.abdominal.toString();
      case 'Coxa':
        return dobrasCutaneas.coxa.toString();
      default:
        return '';
    }
  }

  Future<void> _onSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isSaving = true); // Inicia o feedback de salvamento

      final dobrasCutaneas = DobrasCutaneas(
        protocolo: 'Pollock 7',
        avalicaoId: avaliacaoId!,
        triceps: _parseDoubleValue(controllers[0].text),
        peitoral: _parseDoubleValue(controllers[1].text),
        axilarMedia: _parseDoubleValue(controllers[2].text),
        subescapular: _parseDoubleValue(controllers[3].text),
        supraIliaca: _parseDoubleValue(controllers[4].text),
        abdominal: _parseDoubleValue(controllers[5].text),
        coxa: _parseDoubleValue(controllers[6].text),
      );

      bool hasAll7Measures =
          controllers.every((controller) => controller.text.isNotEmpty);
      final resultado = Resultado.isEmpty();

      if (hasAll7Measures) {
        try {
          final usuario = await LoginController().pegarUsuario();
          final avaliacao =
              await AvaliacaoController().getAvaliacao(avaliacaoId!);
          resultado.pollock7(dobrasCutaneas, usuario, avaliacao);
          AvaliacaoResultadoController().atualizarResultado(
              context, resultado, avaliacaoId!, resultadoId!);
        } catch (e) {
          erro(context, 'Ocorreu um erro: $e');
        }
      }

      isEditing
          ? AvaliacaoDobrasController()
              .atualizarDobras(context, dobrasCutaneas, avaliacaoId!, dobrasId!)
          : AvaliacaoDobrasController()
              .adicionarDobras(context, dobrasCutaneas, avaliacaoId!);

      setState(() => isSaving = false); // Termina o feedback de salvamento
    }
  }

  double _parseDoubleValue(String value) {
    return value.isEmpty ? 0.0 : double.parse(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 176, 225, 231),
        title: const Text('Dobras Cutâneas', style: TextStyle(fontSize: 24)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        ..._buildTextFormFields(),
                        const SizedBox(height: 30),
                        isSaving
                            ? const CircularProgressIndicator() // Feedback de carregamento
                            : ElevatedButton(
                                onPressed: _onSave,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade100,
                                  foregroundColor: Colors.black87,
                                  minimumSize: const Size(200, 40),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 15),
                                  textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Salvar',
                                  style: TextStyle(fontSize: 28),
                                ),
                              ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
    );
  }

  List<Widget> _buildTextFormFields() {
    return List<Widget>.generate(
      labels.length,
      (index) => Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: TextFormField(
          controller: controllers[index],
          decoration: InputDecoration(
            labelText: labels[index],
            prefixIcon: const Icon(Icons.fitness_center),
            suffixText: 'mm',
            suffixStyle: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
