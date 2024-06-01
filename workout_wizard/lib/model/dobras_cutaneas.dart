class DobrasCutaneas {
  //String protocolo;
  double triceps;
  double peitoral;
  double axilarMedia;
  double subescapular;
  double supraIliaca;
  double abdominal;
  double coxa;
  double panturrilha;
  double punho;
  double femur;
  double umero;
  double tornozelo;

  DobrasCutaneas.empty()
      : triceps = 0.0,
        peitoral = 0.0,
        axilarMedia = 0.0,
        subescapular = 0.0,
        supraIliaca = 0.0,
        abdominal = 0.0,
        coxa = 0.0,
        panturrilha = 0.0,
        punho = 0.0,
        femur = 0.0,
        umero = 0.0,
        tornozelo = 0.0;

  DobrasCutaneas({
    //required this.protocolo,
    required this.triceps,
    required this.peitoral,
    required this.axilarMedia,
    required this.subescapular,
    required this.supraIliaca,
    required this.abdominal,
    required this.coxa,
    required this.panturrilha,
    required this.punho,
    required this.femur,
    required this.umero,
    required this.tornozelo,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      //'protocolo': protocolo,
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
