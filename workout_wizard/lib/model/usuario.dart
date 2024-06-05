import 'package:workout_wizard/model/endereco.dart';

class Usuario {
  String? id;
  String nome;
  String cpf;
  Endereco endereco;

  Usuario(this.nome, this.cpf, this.endereco, {this.id});

  Map<String, dynamic> toJson() {
    return {
      'id': id, // 'id' é opcional, pois o Firebase gera automaticamente um 'id' para cada documento
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
      id: json['id'], // Adicionei o id aqui para garantir que ele seja atribuído
    );
  }
}
