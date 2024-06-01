class Exercicio {
  // Campos do documento
  final String uid;
  final String nmExercicio;
  final String grupoMuscular;
  final int carga;
  final int series;
  final int repeticoes;

  // Construtor
  Exercicio(this.uid, this.nmExercicio, this.grupoMuscular, this.carga,
      this.series, this.repeticoes);

  // Transforma um OBJETO em JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'nm_exercicio': nmExercicio,
      'grupo_muscular': grupoMuscular,
      'carga': carga,
      'series': series,
      'repeticoes': repeticoes,
    };
  }

  // Transforma um JSON em OBJETO
  factory Exercicio.fromJson(Map<String, dynamic> json) {
    return Exercicio(
      json['uid'] as String,
      json['nm_exercicio'] as String,
      json['grupo_muscular'] as String,
      json['carga'] as int,
      json['series'] as int,
      json['repeticoes'] as int,
    );
  }
}
