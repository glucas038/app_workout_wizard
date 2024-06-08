class DobrasCutaneas {
  String? protocolo;
  String avalicaoId;
  double? triceps;
  double? peitoral;
  double? axilarMedia;
  double? subescapular;
  double? supraIliaca;
  double? abdominal;
  double? coxa;

  DobrasCutaneas({
    required this.avalicaoId,
    this.protocolo,
    this.triceps,
    this.peitoral,
    this.axilarMedia,
    this.subescapular,
    this.supraIliaca,
    this.abdominal,
    this.coxa,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'avalicaoId': avalicaoId,
      'protocolo': protocolo,
      'triceps': triceps,
      'peitoral': peitoral,
      'axilarMedia': axilarMedia,
      'subescapular': subescapular,
      'supraIliaca': supraIliaca,
      'abdominal': abdominal,
      'coxa': coxa,
    };
  }

  factory DobrasCutaneas.fromJson(Map<String, dynamic> json) {
    return DobrasCutaneas(
      avalicaoId: json['avalicaoId'] as String,
      protocolo: json['protocolo'] as String,
      triceps: (json['triceps'] as num?)?.toDouble() ?? 0.0,
      peitoral: (json['peitoral'] as num?)?.toDouble() ?? 0.0,
      axilarMedia: (json['axilarMedia'] as num?)?.toDouble() ?? 0.0,
      subescapular: (json['subescapular'] as num?)?.toDouble() ?? 0.0,
      supraIliaca: (json['supraIliaca'] as num?)?.toDouble() ?? 0.0,
      abdominal: (json['abdominal'] as num?)?.toDouble() ?? 0.0,
      coxa: (json['coxa'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
