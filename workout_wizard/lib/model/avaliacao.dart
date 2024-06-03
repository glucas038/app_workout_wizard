import 'package:cloud_firestore/cloud_firestore.dart';

class Avaliacao {
  String uId = '';
  DateTime data = DateTime.now();

  double peso;
  double altura;
  double imc = 0.0;

  Avaliacao({
    required this.uId,
    required this.peso,
    required this.altura,
    DateTime? data,
  })  : data = data ?? DateTime.now(),
        imc = (peso / (altura * altura)) * 10000;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uId': uId,
      'data': data,
      'peso': peso,
      'altura': altura,
      'imc': imc,
    };
  }

  factory Avaliacao.fromJson(Map<String, dynamic> json) {
    return Avaliacao(
      uId: json['uId'],
      peso: json['peso'],
      altura: json['altura'],
      data: (json['data'] as Timestamp).toDate(),
    );
  }
}
