import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_wizard/controller/avaliacao_controller.dart';
import 'package:workout_wizard/model/avaliacao.dart';
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

  // Controllers for each field
  final _pescocoController = TextEditingController();
  final _ombroController = TextEditingController();
  final _toraxInspiradoController = TextEditingController();
  final _toraxExpiradoController = TextEditingController();
  final _peitoralController = TextEditingController();
  final _cinturaEscapularController = TextEditingController();
  final _cinturaController = TextEditingController();
  final _abdomenController = TextEditingController();
  final _quadrilController = TextEditingController();
  final _coxaDireitaRelaxadaController = TextEditingController();
  final _coxaDireitaContraidaController = TextEditingController();
  final _coxaEsquerdaRelaxadaController = TextEditingController();
  final _coxaEsquerdaContraidaController = TextEditingController();
  final _panturrilhaDireitaController = TextEditingController();
  final _panturrilhaEsquerdaController = TextEditingController();
  final _bracoRelaxadoDireitaController = TextEditingController();
  final _bracoContraidoDireitaController = TextEditingController();
  final _bracoRelaxadoEsquerdoController = TextEditingController();
  final _bracoContraidoEsquerdoController = TextEditingController();
  final _antebracoDireitoController = TextEditingController();
  final _antebracoEsquerdoController = TextEditingController();
  // Add controllers for other fields as needed

  bool isLoading = true;
  dynamic avaliacao;
  String? errorMessage;
  String docId = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final docId = ModalRoute.of(context)!.settings.arguments as String;
      fetchMedidasCorporais(docId);
      print(docId);
    });
  }

  void fetchMedidasCorporais(String docId) async {
    try {
      final avaliacaoSnapshot =
          await AvaliacaoController().listarAvaliacao(docId).get();
      if (avaliacaoSnapshot.exists) {
        final medidasCorporaisData = avaliacaoSnapshot['medidasCorporais'];
        if (medidasCorporaisData != null) {
          avaliacao = Avaliacao.fromJson(avaliacaoSnapshot.data());
          this.docId = docId;
          final medidasCorporais =
              MedidasCorporais.fromJson(medidasCorporaisData);
          setState(() {
            _pescocoController.text = medidasCorporais.pescoco != 0
                ? medidasCorporais.pescoco.toString()
                : '';
            _ombroController.text = medidasCorporais.ombro != 0
                ? medidasCorporais.ombro.toString()
                : '';
            _toraxInspiradoController.text =
                medidasCorporais.toraxInspirado != 0
                    ? medidasCorporais.toraxInspirado.toString()
                    : '';
            _toraxExpiradoController.text = medidasCorporais.toraxExpirado != 0
                ? medidasCorporais.toraxExpirado.toString()
                : '';
            _peitoralController.text = medidasCorporais.peitoral != 0
                ? medidasCorporais.peitoral.toString()
                : '';
            _cinturaEscapularController.text =
                medidasCorporais.cinturaEscapular != 0
                    ? medidasCorporais.cinturaEscapular.toString()
                    : '';
            _cinturaController.text = medidasCorporais.cintura != 0
                ? medidasCorporais.cintura.toString()
                : '';
            _abdomenController.text = medidasCorporais.abdomen != 0
                ? medidasCorporais.abdomen.toString()
                : '';
            _quadrilController.text = medidasCorporais.quadril != 0
                ? medidasCorporais.quadril.toString()
                : '';
            _coxaDireitaRelaxadaController.text =
                medidasCorporais.coxaDireitaRelaxada != 0
                    ? medidasCorporais.coxaDireitaRelaxada.toString()
                    : '';
            _coxaDireitaContraidaController.text =
                medidasCorporais.coxaDireitaContraida != 0
                    ? medidasCorporais.coxaDireitaContraida.toString()
                    : '';
            _coxaEsquerdaRelaxadaController.text =
                medidasCorporais.coxaEsquerdaRelaxada != 0
                    ? medidasCorporais.coxaEsquerdaRelaxada.toString()
                    : '';
            _coxaEsquerdaContraidaController.text =
                medidasCorporais.coxaEsquerdaContraida != 0
                    ? medidasCorporais.coxaEsquerdaContraida.toString()
                    : '';
            _panturrilhaDireitaController.text =
                medidasCorporais.panturrilhaDireita != 0
                    ? medidasCorporais.panturrilhaDireita.toString()
                    : '';
            _panturrilhaEsquerdaController.text =
                medidasCorporais.panturrilhaEsquerda != 0
                    ? medidasCorporais.panturrilhaEsquerda.toString()
                    : '';
            _bracoRelaxadoDireitaController.text =
                medidasCorporais.bracoRelaxadoDireita != 0
                    ? medidasCorporais.bracoRelaxadoDireita.toString()
                    : '';
            _bracoContraidoDireitaController.text =
                medidasCorporais.bracoContraidoDireita != 0
                    ? medidasCorporais.bracoContraidoDireita.toString()
                    : '';
            _bracoRelaxadoEsquerdoController.text =
                medidasCorporais.bracoRelaxadoEsquerdo != 0
                    ? medidasCorporais.bracoRelaxadoEsquerdo.toString()
                    : '';
            _bracoContraidoEsquerdoController.text =
                medidasCorporais.bracoContraidoEsquerdo != 0
                    ? medidasCorporais.bracoContraidoEsquerdo.toString()
                    : '';
            _antebracoDireitoController.text =
                medidasCorporais.antebracoDireito != 0
                    ? medidasCorporais.antebracoDireito.toString()
                    : '';
            _antebracoEsquerdoController.text =
                medidasCorporais.antebracoEsquerdo != 0
                    ? medidasCorporais.antebracoEsquerdo.toString()
                    : '';
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Dados de medidas corporais não encontrados';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          print(docId);
          errorMessage = 'Documento de avaliação não encontrado';
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
        title: Text('Medidas Corporais'),
        automaticallyImplyLeading: false,
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
                        _buildTextFormField('Pescoço', _pescocoController),
                        _buildTextFormField('Ombro', _ombroController),
                        _buildTextFormField(
                            'Tórax Inspirado', _toraxInspiradoController),
                        _buildTextFormField(
                            'Tórax Expirado', _toraxExpiradoController),
                        _buildTextFormField('Peitoral', _peitoralController),
                        _buildTextFormField(
                            'Cintura Escapular', _cinturaEscapularController),
                        _buildTextFormField('Cintura', _cinturaController),
                        _buildTextFormField('Abdômen', _abdomenController),
                        _buildTextFormField('Quadril', _quadrilController),
                        _buildTextFormField('Coxa Direita Relaxada',
                            _coxaDireitaRelaxadaController),
                        _buildTextFormField('Coxa Direita Contraída',
                            _coxaDireitaContraidaController),
                        _buildTextFormField('Coxa Esquerda Relaxada',
                            _coxaEsquerdaRelaxadaController),
                        _buildTextFormField('Coxa Esquerda Contraída',
                            _coxaEsquerdaContraidaController),
                        _buildTextFormField('Panturrilha Direita',
                            _panturrilhaDireitaController),
                        _buildTextFormField('Panturrilha Esquerda',
                            _panturrilhaEsquerdaController),
                        _buildTextFormField('Braço Relaxado Direita',
                            _bracoRelaxadoDireitaController),
                        _buildTextFormField('Braço Contraído Direita',
                            _bracoContraidoDireitaController),
                        _buildTextFormField('Braço Relaxado Esquerdo',
                            _bracoRelaxadoEsquerdoController),
                        _buildTextFormField('Braço Contraído Esquerdo',
                            _bracoContraidoEsquerdoController),
                        _buildTextFormField(
                            'Antebraço Direito', _antebracoDireitoController),
                        _buildTextFormField(
                            'Antebraço Esquerdo', _antebracoEsquerdoController),
                        // Add other text form fields here
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              MedidasCorporais medidas = MedidasCorporais(
                                pescoco:
                                    parseDoubleValue(_pescocoController.text),
                                ombro: parseDoubleValue(_ombroController.text),
                                toraxInspirado: parseDoubleValue(
                                    _toraxInspiradoController.text),
                                toraxExpirado: parseDoubleValue(
                                    _toraxExpiradoController.text),
                                peitoral:
                                    parseDoubleValue(_peitoralController.text),
                                cinturaEscapular: parseDoubleValue(
                                    _cinturaEscapularController.text),
                                cintura:
                                    parseDoubleValue(_cinturaController.text),
                                abdomen:
                                    parseDoubleValue(_abdomenController.text),
                                quadril:
                                    parseDoubleValue(_quadrilController.text),
                                coxaDireitaRelaxada: parseDoubleValue(
                                    _coxaDireitaRelaxadaController.text),
                                coxaDireitaContraida: parseDoubleValue(
                                    _coxaDireitaContraidaController.text),
                                coxaEsquerdaRelaxada: parseDoubleValue(
                                    _coxaEsquerdaRelaxadaController.text),
                                coxaEsquerdaContraida: parseDoubleValue(
                                    _coxaEsquerdaContraidaController.text),
                                panturrilhaDireita: parseDoubleValue(
                                    _panturrilhaDireitaController.text),
                                panturrilhaEsquerda: parseDoubleValue(
                                    _panturrilhaEsquerdaController.text),
                                bracoRelaxadoDireita: parseDoubleValue(
                                    _bracoRelaxadoDireitaController.text),
                                bracoContraidoDireita: parseDoubleValue(
                                    _bracoContraidoDireitaController.text),
                                bracoRelaxadoEsquerdo: parseDoubleValue(
                                    _bracoRelaxadoEsquerdoController.text),
                                bracoContraidoEsquerdo: parseDoubleValue(
                                    _bracoContraidoEsquerdoController.text),
                                antebracoDireito: parseDoubleValue(
                                    _antebracoDireitoController.text),
                                antebracoEsquerdo: parseDoubleValue(
                                    _antebracoEsquerdoController.text),
                              );

                              avaliacao.medidasCorporais = medidas;
                              AvaliacaoController().atualizarAvaliacao(
                                  context, avaliacao, docId);

                              // Salvar medidas no banco de dados ou realizar outra ação
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
    _pescocoController.dispose();
    _ombroController.dispose();
    _toraxInspiradoController.dispose();
    _toraxExpiradoController.dispose();
    _peitoralController.dispose();
    _cinturaEscapularController.dispose();
    _cinturaController.dispose();
    _abdomenController.dispose();
    _quadrilController.dispose();
    _coxaDireitaRelaxadaController.dispose();
    _coxaDireitaContraidaController.dispose();
    _coxaEsquerdaRelaxadaController.dispose();
    _coxaEsquerdaContraidaController.dispose();
    _panturrilhaDireitaController.dispose();
    _panturrilhaEsquerdaController.dispose();
    _bracoRelaxadoDireitaController.dispose();
    _bracoContraidoDireitaController.dispose();
    _bracoRelaxadoEsquerdoController.dispose();
    _bracoContraidoEsquerdoController.dispose();
    _antebracoDireitoController.dispose();
    _antebracoEsquerdoController.dispose();
    super.dispose();
  }

  double parseDoubleValue(String value) {
    if (value.isEmpty) {
      return 0.0;
    }
    return double.parse(value);
  }
}
