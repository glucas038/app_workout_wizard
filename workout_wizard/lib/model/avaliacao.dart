import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workout_wizard/model/dobras_cutaneas.dart';
import 'package:workout_wizard/model/medidas_corporais.dart';

class Avaliacao {
  DateTime data = DateTime.now();

  double peso;
  double altura;
  double imc = 0.0;
  DobrasCutaneas dobrasCutaneas = DobrasCutaneas.empty();
  MedidasCorporais medidasCorporais = MedidasCorporais.empty();

  Avaliacao({
    required this.peso,
    required this.altura,
    DateTime? data,
    DobrasCutaneas? dobrasCutaneas,
    MedidasCorporais? medidasCorporais,
  })  : data = data ?? DateTime.now(),
        dobrasCutaneas = dobrasCutaneas ?? DobrasCutaneas.empty(),
        medidasCorporais = medidasCorporais ?? MedidasCorporais.empty(),
        imc = (peso / (altura * altura)) * 10000;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'data': data,
      'peso': peso,
      'altura': altura,
      'imc': imc,
      'dobrasCutaneas': dobrasCutaneas.toJson(), // Serializando DobrasCutaneas
      'medidasCorporais':
          medidasCorporais.toJson(), // Serializando MedidasCorporais
    };
  }

  factory Avaliacao.fromJson(Map<String, dynamic> json) {
    return Avaliacao(
      peso: json['peso'],
      altura: json['altura'],
      data: (json['data'] as Timestamp).toDate(),
// Desserializando a data
      dobrasCutaneas: DobrasCutaneas.fromJson(json['dobrasCutaneas']),
      medidasCorporais: MedidasCorporais.fromJson(json['medidasCorporais']),
    );
  }
}
