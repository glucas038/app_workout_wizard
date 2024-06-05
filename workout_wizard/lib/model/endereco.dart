class Endereco {
  String rua;
  String cidade;
  String estado;
  String cep;
  String numero;

  Endereco(this.rua, this.cidade, this.estado, this.cep, this.numero);

  Map<String, dynamic> toJson() {
    return {
      'rua': rua,
      'cidade': cidade,
      'estado': estado,
      'cep': cep,
      'numero': numero,
    };
  }

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      json['rua'], 
      json['cidade'], 
      json['estado'], 
      json['cep'], 
      json['numero']
      );
  }
}
