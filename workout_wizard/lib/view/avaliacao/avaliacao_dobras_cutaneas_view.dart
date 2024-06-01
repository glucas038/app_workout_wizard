import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workout_wizard/controller/avaliacao_controller.dart';
import 'package:workout_wizard/model/avaliacao.dart';
import 'package:workout_wizard/model/dobras_cutaneas.dart';
import 'package:workout_wizard/model/medidas_corporais.dart';

class AvaliacaoDobrasCutaneasView extends StatefulWidget {
  const AvaliacaoDobrasCutaneasView({Key? key}) : super(key: key);

  @override
  _AvaliacaoDobrasCutaneasViewState createState() =>
      _AvaliacaoDobrasCutaneasViewState();
}

class _AvaliacaoDobrasCutaneasViewState
    extends State<AvaliacaoDobrasCutaneasView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each field
  final _tricepsController = TextEditingController();
  final _peitoralController = TextEditingController();
  final _axilarMediaController = TextEditingController();
  final _subescapularController = TextEditingController();
  final _supraIliacaController = TextEditingController();
  final _abdominalController = TextEditingController();
  final _coxaController = TextEditingController();
  final _panturrilhaController = TextEditingController();
  final _punhoController = TextEditingController();
  final _femurController = TextEditingController();
  final _umeroController = TextEditingController();
  final _tornozeloController = TextEditingController();
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
      fetchDobrasCutaneas(docId);
      print(docId);
    });
  }

  void fetchDobrasCutaneas(String docId) async {
    try {
      final avaliacaoSnapshot =
          await AvaliacaoController().listarAvaliacao(docId).get();
      if (avaliacaoSnapshot.exists) {
        final dobrasCutaneasData = avaliacaoSnapshot['dobrasCutaneas'];
        if (dobrasCutaneasData != null) {
          avaliacao = Avaliacao.fromJson(avaliacaoSnapshot.data());
          this.docId = docId;
          final dobrasCutaneas = DobrasCutaneas.fromJson(dobrasCutaneasData);
          setState(() {
            _tricepsController.text = dobrasCutaneas.triceps != 0
                ? dobrasCutaneas.triceps.toString()
                : '';
            _peitoralController.text = dobrasCutaneas.peitoral != 0
                ? dobrasCutaneas.peitoral.toString()
                : '';
            _axilarMediaController.text = dobrasCutaneas.axilarMedia != 0
                ? dobrasCutaneas.axilarMedia.toString()
                : '';
            _subescapularController.text = dobrasCutaneas.subescapular != 0
                ? dobrasCutaneas.subescapular.toString()
                : '';
            _supraIliacaController.text = dobrasCutaneas.supraIliaca != 0
                ? dobrasCutaneas.supraIliaca.toString()
                : '';
            _abdominalController.text = dobrasCutaneas.abdominal != 0
                ? dobrasCutaneas.abdominal.toString()
                : '';
            _coxaController.text =
                dobrasCutaneas.coxa != 0 ? dobrasCutaneas.coxa.toString() : '';
            _panturrilhaController.text = dobrasCutaneas.panturrilha != 0
                ? dobrasCutaneas.panturrilha.toString()
                : '';
            _punhoController.text = dobrasCutaneas.punho != 0
                ? dobrasCutaneas.punho.toString()
                : '';
            _femurController.text = dobrasCutaneas.femur != 0
                ? dobrasCutaneas.femur.toString()
                : '';
            _umeroController.text = dobrasCutaneas.umero != 0
                ? dobrasCutaneas.umero.toString()
                : '';
            _tornozeloController.text = dobrasCutaneas.tornozelo != 0
                ? dobrasCutaneas.tornozelo.toString()
                : '';
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Dados de dobras cutaneas não encontrados';
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
        title: Text('Dobras Cutaneas'),
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
                        _buildTextFormField('Tríceps', _tricepsController),
                        _buildTextFormField('Peitoral', _peitoralController),
                        _buildTextFormField(
                            'Axilar Média', _axilarMediaController),
                        _buildTextFormField(
                            'Subescapular', _subescapularController),
                        _buildTextFormField(
                            'Supra-ilíaca', _supraIliacaController),
                        _buildTextFormField('Abdominal', _abdominalController),
                        _buildTextFormField('Coxa', _coxaController),
                        _buildTextFormField(
                            'Panturrilha', _panturrilhaController),
                        _buildTextFormField('Punho', _punhoController),
                        _buildTextFormField('Fêmur', _femurController),
                        _buildTextFormField('Úmero', _umeroController),
                        _buildTextFormField('Tornozelo', _tornozeloController),
                        // Add other text form fields here
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              DobrasCutaneas dobrasCutaneas = DobrasCutaneas(
                                triceps:
                                    parseDoubleValue(_tricepsController.text),
                                peitoral:
                                    parseDoubleValue(_peitoralController.text),
                                axilarMedia: parseDoubleValue(
                                    _axilarMediaController.text),
                                subescapular: parseDoubleValue(
                                    _subescapularController.text),
                                supraIliaca: parseDoubleValue(
                                    _supraIliacaController.text),
                                abdominal:
                                    parseDoubleValue(_abdominalController.text),
                                coxa: parseDoubleValue(_coxaController.text),
                                panturrilha: parseDoubleValue(
                                    _panturrilhaController.text),
                                punho: parseDoubleValue(_punhoController.text),
                                femur: parseDoubleValue(_femurController.text),
                                umero: parseDoubleValue(_umeroController.text),
                                tornozelo:
                                    parseDoubleValue(_tornozeloController.text),
                              );

                              avaliacao.dobrasCutaneas = dobrasCutaneas;
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
    _tricepsController.dispose();
    _peitoralController.dispose();
    _axilarMediaController.dispose();
    _subescapularController.dispose();
    _supraIliacaController.dispose();
    _abdominalController.dispose();
    _coxaController.dispose();
    _panturrilhaController.dispose();
    _punhoController.dispose();
    _femurController.dispose();
    _umeroController.dispose();
    _tornozeloController.dispose();
    super.dispose();
  }

  double parseDoubleValue(String value) {
    if (value.isEmpty) {
      return 0.0;
    }
    return double.parse(value);
  }
}
