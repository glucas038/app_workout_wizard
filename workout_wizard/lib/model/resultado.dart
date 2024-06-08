import 'package:workout_wizard/model/avaliacao.dart';
import 'package:workout_wizard/model/dobras_cutaneas.dart';
import 'package:workout_wizard/model/usuario.dart';

class Resultado {
  String avaliacaoId;
  double perGordura;
  double pesoGordura;
  double perMagra;
  double pesoMagra;
  double pesoOsseo;
  double pesoResidual;
  double pesoMuscular;

  Resultado.isEmpty()
      : avaliacaoId = '',
        perGordura = 0.0,
        pesoGordura = 0.0,
        perMagra = 0.0,
        pesoMagra = 0.0,
        pesoOsseo = 0.0,
        pesoResidual = 0.0,
        pesoMuscular = 0.0;
      

  Resultado({
    required this.avaliacaoId,
    required this.perGordura,
    required this.pesoGordura,
    required this.perMagra,
    required this.pesoMagra,
    required this.pesoOsseo,
    required this.pesoResidual,
    required this.pesoMuscular,
  });

  Map<String, dynamic> toJson() {
    return {
      'avaliacaoId': avaliacaoId,
      'perGordura': perGordura,
      'pesoGordura': pesoGordura,
      'perMagra': perMagra,
      'pesoMagra': pesoMagra,
      'pesoOsseo': pesoOsseo,
      'pesoResidual': pesoResidual,
      'pesoMuscular': pesoMuscular,
    };
  }

  factory Resultado.fromJson(Map<String, dynamic> json) {
    return Resultado(
      avaliacaoId: json['avaliacaoId'],
      perGordura: json['perGordura'],
      pesoGordura: json['pesoGordura'],
      perMagra: json['perMagra'],
      pesoMagra: json['pesoMagra'],
      pesoOsseo: json['pesoOsseo'],
      pesoResidual: json['pesoResidual'],
      pesoMuscular: json['pesoMuscular'],
    );
  }

  void pollock7(DobrasCutaneas dobras, Usuario usuario, Avaliacao avaliacao) {
    double somaDobras = dobras.triceps! +
        dobras.peitoral! +
        dobras.axilarMedia! +
        dobras.subescapular! +
        dobras.supraIliaca! +
        dobras.abdominal! +
        dobras.coxa!;

    double DC;
    if (usuario.sexo == "M") {
      DC = 1.112 -
          (0.00043499 * somaDobras) +
          (0.00000055 * somaDobras * somaDobras) -
          (0.00028826 * usuario.idade);
    } else if (usuario.sexo == "F") {
      DC = 1.097 -
          (0.00046971 * somaDobras) +
          (0.00000056 * somaDobras * somaDobras) -
          (0.00012828 * usuario.idade);
    } else {
      throw Exception("Sexo não reconhecido.");
    }

    perGordura = (495 / DC) - 450;
    pesoGordura = perGordura * avaliacao.peso / 100;
    perMagra = 100 - perGordura;
    pesoMagra = avaliacao.peso - pesoGordura;
    pesoOsseo = 0.15 * avaliacao.peso;
    pesoResidual =
        (usuario.sexo == "M" ? 0.241 * avaliacao.peso : 0.209 * avaliacao.peso);
    pesoMuscular = avaliacao.peso - pesoGordura - pesoOsseo - pesoResidual;

  }

  @override
  String toString() {
    return 'Resultado{perGordura: $perGordura, pesoGordura: $pesoGordura, perMagra: $perMagra, pesoMagra: $pesoMagra, pesoOsseo: $pesoOsseo, pesoResidual: $pesoResidual, pesoMuscular: $pesoMuscular}';
  }
}
