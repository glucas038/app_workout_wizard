import 'package:cloud_firestore/cloud_firestore.dart';

class Avaliacao {
  String uid = '';
  DateTime data = DateTime.now();

  double peso;
  double altura;
  double imc = 0.0;

  Avaliacao({
    required this.uid,
    required this.peso,
    required this.altura,
    DateTime? data,
  })  : data = data ?? DateTime.now(),
        imc = (peso / (altura * altura)) * 10000;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'data': data,
      'peso': peso,
      'altura': altura,
      'imc': imc,
    };
  }

  factory Avaliacao.fromJson(Map<String, dynamic> json) {
    return Avaliacao(
      uid: json['uId'],
      peso: json['peso'],
      altura: json['altura'],
      data: (json['data'] as Timestamp).toDate(),
    );
  }
}
