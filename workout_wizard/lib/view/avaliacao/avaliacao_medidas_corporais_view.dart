import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_wizard/controller/avaliacao_medidas_controller.dart';
import 'package:workout_wizard/controller/login_controller.dart';

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

  List<String>? labels = [
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
    'Antebraço Esquerdo',
  ];

  List<TextEditingController>? controllers = List.generate(
    21, // Usando a lista labels já inicializada
    (_) => TextEditingController(),
  );

  bool isLoading = true;
  String? errorMessage;
  String? avaliacaoId;
  bool isEditing = false;
  String? medidasId;

  @override
  void initState() {
    super.initState();
    @override
    void initState() {
      super.initState();

      WidgetsBinding.instance!.addPostFrameCallback((_) {
        avaliacaoId = ModalRoute.of(context)!.settings.arguments as String;
        fetchMedidasCorporais();
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      avaliacaoId = ModalRoute.of(context)!.settings.arguments as String;
      fetchMedidasCorporais();
    });
  }

  void fetchMedidasCorporais() async {
    try {
      if (avaliacaoId != null) {
        final medidasSnapshot =
            await AvaliacaoMedidasController.listarMedidas(avaliacaoId!);

        print(medidasSnapshot.docs.isNotEmpty);
        print(medidasSnapshot.docs.toString());
        if (medidasSnapshot.docs.isNotEmpty) {
          isEditing = true;
          medidasId = medidasSnapshot.docs.first.id;

          final medidasData =
              medidasSnapshot.docs.first.data() as Map<String, dynamic>;
          print(medidasData.toString());
          print(medidasData != null);
          if (medidasData != null) {
            final medidasCorporais = MedidasCorporais.fromJson(medidasData);
            setState(() {
              for (int i = 0; i < labels!.length; i++) {
                final String label = labels![i];
                final String value = getValueByLabel(label, medidasCorporais);
                controllers![i].text = (value != '0') ? value : '';
              }
              isLoading = false;
            });
          }
        } else {
          setState(() {
            //errorMessage = 'Documento de avaliação não encontrado';
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
        backgroundColor: Colors.green.shade200,
        title: Text('Medidas Corporais'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        for (int i = 0; i < labels!.length; i++)
                          _buildTextFormField(labels![i], controllers![i]),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final medidasCorporais = MedidasCorporais(
                                avalicaoId: avaliacaoId!,
                                pescoco: parseDoubleValue(controllers![0].text),
                                ombro: parseDoubleValue(controllers![1].text),
                                toraxInspirado:
                                    parseDoubleValue(controllers![2].text),
                                toraxExpirado:
                                    parseDoubleValue(controllers![3].text),
                                peitoral:
                                    parseDoubleValue(controllers![4].text),
                                cinturaEscapular:
                                    parseDoubleValue(controllers![5].text),
                                cintura: parseDoubleValue(controllers![6].text),
                                abdomen: parseDoubleValue(controllers![7].text),
                                quadril: parseDoubleValue(controllers![8].text),
                                coxaDireitaRelaxada:
                                    parseDoubleValue(controllers![9].text),
                                coxaDireitaContraida:
                                    parseDoubleValue(controllers![10].text),
                                coxaEsquerdaRelaxada:
                                    parseDoubleValue(controllers![11].text),
                                coxaEsquerdaContraida:
                                    parseDoubleValue(controllers![12].text),
                                panturrilhaDireita:
                                    parseDoubleValue(controllers![13].text),
                                panturrilhaEsquerda:
                                    parseDoubleValue(controllers![14].text),
                                bracoRelaxadoDireita:
                                    parseDoubleValue(controllers![15].text),
                                bracoContraidoDireita:
                                    parseDoubleValue(controllers![16].text),
                                bracoRelaxadoEsquerdo:
                                    parseDoubleValue(controllers![17].text),
                                bracoContraidoEsquerdo:
                                    parseDoubleValue(controllers![18].text),
                                antebracoDireito:
                                    parseDoubleValue(controllers![19].text),
                                antebracoEsquerdo:
                                    parseDoubleValue(controllers![20].text),
                              );

                              isEditing
                                  ? AvaliacaoMedidasController()
                                      .atualizarMedidas(
                                          context,
                                          medidasCorporais,
                                          avaliacaoId!,
                                          medidasId!)
                                  : AvaliacaoMedidasController()
                                      .adicionarMedidas(context,
                                          medidasCorporais, avaliacaoId!);
                            }
                          },
                          child: Text('Salvar'),
                        ),
                        SizedBox(height: 40),
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
          prefixIcon: Icon(Icons.fitness_center),
          prefixText: '   ', // Add space for the icon and suffix
          suffixText: 'cm',
          suffixStyle: TextStyle(
            color: Colors.grey, // Suffix color
            fontWeight: FontWeight.bold, // Font weight
            fontSize: 16, // Font size
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
        ], // Allow only numbers and dot
      ),
    );
  }

  @override
  void dispose() {
    controllers!.forEach((controller) => controller.dispose());
    super.dispose();
  }

  double parseDoubleValue(String value) {
    if (value.isEmpty) {
      return 0.0;
    }
    return double.parse(value);
  }
}
