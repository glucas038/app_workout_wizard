import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_wizard/controller/avaliacao_medidas_controller.dart';
import 'package:workout_wizard/model/medidas_corporais.dart';

class AvaliacaoMedidasCorporaisView extends StatefulWidget {
  const AvaliacaoMedidasCorporaisView({Key? key}) : super(key: key);

  @override
  _AvaliacaoMedidasCorporaisViewState createState() =>
      _AvaliacaoMedidasCorporaisViewState();
}

class _AvaliacaoMedidasCorporaisViewState
    extends State<AvaliacaoMedidasCorporaisView> {
  final _formKey = GlobalKey<FormState>();

  final List<String> labels = [
    'Pescoço',
    'Ombro',
    'Toráx Inspirado',
    'Toráx Expirado',
    'Peitoral',
    'Cintura Escapular',
    'Cintura',
    'Abdomen',
    'Quadril',
    'Coxa Direita Relaxada',
    'Coxa Direita Contraída',
    'Coxa Esquerda Relaxada',
    'Coxa Esquerda Contraída',
    'Panturrilha Direita',
    'Panturrilha Esquerda',
    'Braço Relaxado Direito',
    'Braço Contraído Direito',
    'Braço Relaxado Esquerdo',
    'Braço Contraído Esquerdo',
    'Antebraço Direito',
    'Antebraço Esquerdo'
  ];

  final List<TextEditingController> controllers =
      List.generate(21, (_) => TextEditingController());

  bool isLoading = true;
  String? errorMessage;
  String? avaliacaoId;
  bool isEditing = false;
  String? medidasId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      avaliacaoId = ModalRoute.of(context)!.settings.arguments as String?;
      if (avaliacaoId != null) {
        fetchMedidasCorporais();
      }
    });
  }

  Future<void> fetchMedidasCorporais() async {
    try {
      final medidasSnapshot =
          await AvaliacaoMedidasController.listarMedidas(avaliacaoId!);
      if (medidasSnapshot.docs.isNotEmpty) {
        isEditing = true;
        medidasId = medidasSnapshot.docs.first.id;
        final medidasData =
            medidasSnapshot.docs.first.data() as Map<String, dynamic>;
        if (medidasData != null) {
          final medidasCorporais = MedidasCorporais.fromJson(medidasData);
          for (int i = 0; i < labels.length; i++) {
            final String label = labels[i];
            final String value = getValueByLabel(label, medidasCorporais);
            controllers[i].text = (value != '0') ? value : '';
          }
        }
      }
      setState(() => isLoading = false);
    } catch (error) {
      setState(() {
        errorMessage = 'Erro ao buscar dados: $error';
        isLoading = false;
      });
    }
  }

  String getValueByLabel(String label, MedidasCorporais medidasCorporais) {
    switch (label) {
      case 'Pescoço':
        return medidasCorporais.pescoco.toString();
      case 'Ombro':
        return medidasCorporais.ombro.toString();
      case 'Toráx Inspirado':
        return medidasCorporais.toraxInspirado.toString();
      case 'Toráx Expirado':
        return medidasCorporais.toraxExpirado.toString();
      case 'Peitoral':
        return medidasCorporais.peitoral.toString();
      case 'Cintura Escapular':
        return medidasCorporais.cinturaEscapular.toString();
      case 'Cintura':
        return medidasCorporais.cintura.toString();
      case 'Abdomen':
        return medidasCorporais.abdomen.toString();
      case 'Quadril':
        return medidasCorporais.quadril.toString();
      case 'Coxa Direita Relaxada':
        return medidasCorporais.coxaDireitaRelaxada.toString();
      case 'Coxa Direita Contraída':
        return medidasCorporais.coxaDireitaContraida.toString();
      case 'Coxa Esquerda Relaxada':
        return medidasCorporais.coxaEsquerdaRelaxada.toString();
      case 'Coxa Esquerda Contraída':
        return medidasCorporais.coxaEsquerdaContraida.toString();
      case 'Panturrilha Direita':
        return medidasCorporais.panturrilhaDireita.toString();
      case 'Panturrilha Esquerda':
        return medidasCorporais.panturrilhaEsquerda.toString();
      case 'Braço Relaxado Direito':
        return medidasCorporais.bracoRelaxadoDireita.toString();
      case 'Braço Contraído Direito':
        return medidasCorporais.bracoContraidoDireita.toString();
      case 'Braço Relaxado Esquerdo':
        return medidasCorporais.bracoRelaxadoEsquerdo.toString();
      case 'Braço Contraído Esquerdo':
        return medidasCorporais.bracoContraidoEsquerdo.toString();
      case 'Antebraço Direito':
        return medidasCorporais.antebracoDireito.toString();
      case 'Antebraço Esquerdo':
        return medidasCorporais.antebracoEsquerdo.toString();
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 176, 225, 231),
        title: const Text('Medidas Corporais', style: TextStyle(fontSize: 24)),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < labels.length; i++)
                          _buildTextFormField(labels[i], controllers[i]),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () => _saveMedidasCorporais(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade100,
                              foregroundColor: Colors.black87,
                              minimumSize: const Size(200, 40),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              textStyle: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Salvar',
                                style: TextStyle(fontSize: 28)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.fitness_center),
          suffixText: 'cm',
          suffixStyle: const TextStyle(
              color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16),
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
        ],
      ),
    );
  }

  void _saveMedidasCorporais() {
    if (_formKey.currentState!.validate()) {
      final medidasCorporais = MedidasCorporais(
        avalicaoId: avaliacaoId!,
        pescoco: _parseDouble(controllers[0].text),
        ombro: _parseDouble(controllers[1].text),
        toraxInspirado: _parseDouble(controllers[2].text),
        toraxExpirado: _parseDouble(controllers[3].text),
        peitoral: _parseDouble(controllers[4].text),
        cinturaEscapular: _parseDouble(controllers[5].text),
        cintura: _parseDouble(controllers[6].text),
        abdomen: _parseDouble(controllers[7].text),
        quadril: _parseDouble(controllers[8].text),
        coxaDireitaRelaxada: _parseDouble(controllers[9].text),
        coxaDireitaContraida: _parseDouble(controllers[10].text),
        coxaEsquerdaRelaxada: _parseDouble(controllers[11].text),
        coxaEsquerdaContraida: _parseDouble(controllers[12].text),
        panturrilhaDireita: _parseDouble(controllers[13].text),
        panturrilhaEsquerda: _parseDouble(controllers[14].text),
        bracoRelaxadoDireita: _parseDouble(controllers[15].text),
        bracoContraidoDireita: _parseDouble(controllers[16].text),
        bracoRelaxadoEsquerdo: _parseDouble(controllers[17].text),
        bracoContraidoEsquerdo: _parseDouble(controllers[18].text),
        antebracoDireito: _parseDouble(controllers[19].text),
        antebracoEsquerdo: _parseDouble(controllers[20].text),
      );

      if (isEditing) {
        AvaliacaoMedidasController().atualizarMedidas(
            context, medidasCorporais, avaliacaoId!, medidasId!);
      } else {
        AvaliacaoMedidasController()
            .adicionarMedidas(context, medidasCorporais, avaliacaoId!);
      }
    }
  }

  double _parseDouble(String value) =>
      value.isEmpty ? 0.0 : double.parse(value);

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
