import 'package:workout_wizard/model/endereco.dart';

class Usuario {
  String? id;
  String nome;
  String sexo;
  double idade;
  String cpf;
  Endereco endereco;

  Usuario(this.nome, this.cpf, this.endereco, this.sexo, this.idade, {this.id});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sexo': sexo,
      'idade': idade,
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
      (json['idade'] as num?)?.toDouble() ?? 0.0,
      id: json['id'],
    );
  }
}
