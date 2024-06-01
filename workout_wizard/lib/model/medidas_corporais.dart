class MedidasCorporais {
  double pescoco;
  double ombro;
  double toraxInspirado;
  double toraxExpirado;
  double peitoral;
  double cinturaEscapular;
  double cintura;
  double abdomen;
  double quadril;
  double coxaDireitaRelaxada;
  double coxaDireitaContraida;
  double coxaEsquerdaRelaxada;
  double coxaEsquerdaContraida;
  double panturrilhaDireita;
  double panturrilhaEsquerda;
  double bracoRelaxadoDireita;
  double bracoContraidoDireita;
  double bracoRelaxadoEsquerdo;
  double bracoContraidoEsquerdo;
  double antebracoDireito;
  double antebracoEsquerdo;

  MedidasCorporais.empty()
      : pescoco = 0.0,
        ombro = 0.0,
        toraxInspirado = 0.0,
        toraxExpirado = 0.0,
        peitoral = 0.0,
        cinturaEscapular = 0.0,
        cintura = 0.0,
        abdomen = 0.0,
        quadril = 0.0,
        coxaDireitaRelaxada = 0.0,
        coxaDireitaContraida = 0.0,
        coxaEsquerdaRelaxada = 0.0,
        coxaEsquerdaContraida = 0.0,
        panturrilhaDireita = 0.0,
        panturrilhaEsquerda = 0.0,
        bracoRelaxadoDireita = 0.0,
        bracoContraidoDireita = 0.0,
        bracoRelaxadoEsquerdo = 0.0,
        bracoContraidoEsquerdo = 0.0,
        antebracoDireito = 0.0,
        antebracoEsquerdo = 0.0;

  MedidasCorporais({
    required this.pescoco,
    required this.ombro,
    required this.toraxInspirado,
    required this.toraxExpirado,
    required this.peitoral,
    required this.cinturaEscapular,
    required this.cintura,
    required this.abdomen,
    required this.quadril,
    required this.coxaDireitaRelaxada,
    required this.coxaDireitaContraida,
    required this.coxaEsquerdaRelaxada,
    required this.coxaEsquerdaContraida,
    required this.panturrilhaDireita,
    required this.panturrilhaEsquerda,
    required this.bracoRelaxadoDireita,
    required this.bracoContraidoDireita,
    required this.bracoRelaxadoEsquerdo,
    required this.bracoContraidoEsquerdo,
    required this.antebracoDireito,
    required this.antebracoEsquerdo,
  });

 Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'pescoco': pescoco,
      'ombro': ombro,
      'toraxInspirado': toraxInspirado,
      'toraxExpirado': toraxExpirado,
      'peitoral': peitoral,
      'cinturaEscapular': cinturaEscapular,
      'cintura': cintura,
      'abdomen': abdomen,
      'quadril': quadril,
      'coxaDireitaRelaxada': coxaDireitaRelaxada,
      'coxaDireitaContraida': coxaDireitaContraida,
      'coxaEsquerdaRelaxada': coxaEsquerdaRelaxada,
      'coxaEsquerdaContraida': coxaEsquerdaContraida,
      'panturrilhaDireita': panturrilhaDireita,
      'panturrilhaEsquerda': panturrilhaEsquerda,
      'bracoRelaxadoDireita': bracoRelaxadoDireita,
      'bracoContraidoDireita': bracoContraidoDireita,
      'bracoRelaxadoEsquerdo': bracoRelaxadoEsquerdo,
      'bracoContraidoEsquerdo': bracoContraidoEsquerdo,
      'antebracoDireito': antebracoDireito,
      'antebracoEsquerdo': antebracoEsquerdo,
    };
  }

  factory MedidasCorporais.fromJson(Map<String, dynamic> json) {
  return MedidasCorporais(
    pescoco: (json['pescoco'] as num?)?.toDouble() ?? 0.0,
    ombro: (json['ombro'] as num?)?.toDouble() ?? 0.0,
    toraxInspirado: (json['toraxInspirado'] as num?)?.toDouble() ?? 0.0,
    toraxExpirado: (json['toraxExpirado'] as num?)?.toDouble() ?? 0.0,
    peitoral: (json['peitoral'] as num?)?.toDouble() ?? 0.0,
    cinturaEscapular: (json['cinturaEscapular'] as num?)?.toDouble() ?? 0.0,
    cintura: (json['cintura'] as num?)?.toDouble() ?? 0.0,
    abdomen: (json['abdomen'] as num?)?.toDouble() ?? 0.0,
    quadril: (json['quadril'] as num?)?.toDouble() ?? 0.0,
    coxaDireitaRelaxada: (json['coxaDireitaRelaxada'] as num?)?.toDouble() ?? 0.0,
    coxaDireitaContraida: (json['coxaDireitaContraida'] as num?)?.toDouble() ?? 0.0,
    coxaEsquerdaRelaxada: (json['coxaEsquerdaRelaxada'] as num?)?.toDouble() ?? 0.0,
    coxaEsquerdaContraida: (json['coxaEsquerdaContraida'] as num?)?.toDouble() ?? 0.0,
    panturrilhaDireita: (json['panturrilhaDireita'] as num?)?.toDouble() ?? 0.0,
    panturrilhaEsquerda: (json['panturrilhaEsquerda'] as num?)?.toDouble() ?? 0.0,
    bracoRelaxadoDireita: (json['bracoRelaxadoDireita'] as num?)?.toDouble() ?? 0.0,
    bracoContraidoDireita: (json['bracoContraidoDireita'] as num?)?.toDouble() ?? 0.0,
    bracoRelaxadoEsquerdo: (json['bracoRelaxadoEsquerdo'] as num?)?.toDouble() ?? 0.0,
    bracoContraidoEsquerdo: (json['bracoContraidoEsquerdo'] as num?)?.toDouble() ?? 0.0,
    antebracoDireito: (json['antebracoDireito'] as num?)?.toDouble() ?? 0.0,
    antebracoEsquerdo: (json['antebracoEsquerdo'] as num?)?.toDouble() ?? 0.0,
  );
}


}
