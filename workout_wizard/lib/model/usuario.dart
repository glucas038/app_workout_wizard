import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workout_wizard/model/endereco.dart';

class Usuario {
  String? id;
  String nome;
  String sexo;
  DateTime dataNascimento;
  String cpf;
  Endereco endereco;

  Usuario(this.nome, this.cpf, this.endereco, this.sexo, this.dataNascimento,
      {this.id});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sexo': sexo,
      'dataNascimento': dataNascimento,
      'nome': nome,
      'cpf': cpf,
      'endereco': endereco.toJson(),
    };
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      json['nome'],
      json['cpf'],
      Endereco.fromJson(json['endereco']),
      json['sexo'],
      (json['dataNascimento'] as Timestamp).toDate(),
      id: json['id'],
    );
  }
}
