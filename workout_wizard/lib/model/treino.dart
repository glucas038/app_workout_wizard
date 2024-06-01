class Treino {
  //campos do documento
  final String uid;
  final String dsTreino;

  Treino(this.uid, this.dsTreino);

  //
  // Transforma um OBJETO em JSON
  //
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'uid': uid, 'ds_treino': dsTreino};
  }

  //
  // Transforma um JSON em OBJETO
  //
  factory Treino.fromJson(Map<String, dynamic> json) {
    return Treino(json['uid'], json['ds_treino']);
  }
}
