import 'package:cloud_firestore/cloud_firestore.dart';

class Avaliacao {
  String uid = '';
  DateTime data = DateTime.now();

  double peso;
  double altura;
  double? imc;

  Avaliacao({
    required this.uid,
    required this.peso,
    required this.altura,
    DateTime? data,
    required this.imc,
  }) : data = data ?? DateTime.now();

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
      uid: json['uid'],
      peso: (json['peso'] as num?)?.toDouble() ?? 0.0,
      altura: (json['altura'] as num?)?.toDouble() ?? 0.0,
      imc: (json['imc'] as num?)?.toDouble() ?? 0.0,
      data: (json['data'] as Timestamp).toDate(),
    );
  }
}
