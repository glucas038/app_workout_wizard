class DobrasCutaneas {
  //String protocolo;
  String avalicaoId;
  double? triceps;
  double? peitoral;
  double? axilarMedia;
  double? subescapular;
  double? supraIliaca;
  double? abdominal;
  double? coxa;
  double? panturrilha;
  double? punho;
  double? femur;
  double? umero;
  double? tornozelo;

  DobrasCutaneas({
    required this.avalicaoId,
    this.triceps,
    this.peitoral,
    this.axilarMedia,
    this.subescapular,
    this.supraIliaca,
    this.abdominal,
    this.coxa,
    this.panturrilha,
    this.punho,
    this.femur,
    this.umero,
    this.tornozelo,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      //'protocolo': protocolo,
      'avalicaoId': avalicaoId, // 'uId' é o 'id' do usuário, que é o 'uId' do 'FirebaseAuth
      'triceps': triceps,
      'peitoral': peitoral,
      'axilarMedia': axilarMedia,
      'subscapular': subescapular,
      'supraIliaca': supraIliaca,
      'abdominal': abdominal,
      'coxa': coxa,
      'panturrilha': panturrilha,
      'punho': punho,
      'femur': femur,
      'umero': umero,
      'tornozelo': tornozelo,
    };
  }

  factory DobrasCutaneas.fromJson(Map<String, dynamic> json) {
    return DobrasCutaneas(
      avalicaoId: json['avalicaoId'] as String,
      triceps: (json['triceps'] as num?)?.toDouble() ?? 0.0,
      peitoral: (json['peitoral'] as num?)?.toDouble() ?? 0.0,
      axilarMedia: (json['axilarMedia'] as num?)?.toDouble() ?? 0.0,
      subescapular: (json['subescapular'] as num?)?.toDouble() ?? 0.0,
      supraIliaca: (json['supraIliaca'] as num?)?.toDouble() ?? 0.0,
      abdominal: (json['abdominal'] as num?)?.toDouble() ?? 0.0,
      coxa: (json['coxa'] as num?)?.toDouble() ?? 0.0,
      panturrilha: (json['panturrilha'] as num?)?.toDouble() ?? 0.0,
      punho: (json['punho'] as num?)?.toDouble() ?? 0.0,
      femur: (json['femur'] as num?)?.toDouble() ?? 0.0,
      umero: (json['umero'] as num?)?.toDouble() ?? 0.0,
      tornozelo: (json['tornozelo'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
