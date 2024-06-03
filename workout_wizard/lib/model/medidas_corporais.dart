class MedidasCorporais {
  String avalicaoId;
  double? pescoco;
double? ombro;
double? toraxInspirado;
double? toraxExpirado;
double? peitoral;
double? cinturaEscapular;
double? cintura;
double? abdomen;
double? quadril;
double? coxaDireitaRelaxada;
double? coxaDireitaContraida;
double? coxaEsquerdaRelaxada;
double? coxaEsquerdaContraida;
double? panturrilhaDireita;
double? panturrilhaEsquerda;
double? bracoRelaxadoDireita;
double? bracoContraidoDireita;
double? bracoRelaxadoEsquerdo;
double? bracoContraidoEsquerdo;
double? antebracoDireito;
double? antebracoEsquerdo;




  MedidasCorporais({
    required this.avalicaoId,
    this.pescoco,
  this.ombro,
  this.toraxInspirado,
  this.toraxExpirado,
  this.peitoral,
  this.cinturaEscapular,
  this.cintura,
  this.abdomen,
  this.quadril,
  this.coxaDireitaRelaxada,
  this.coxaDireitaContraida,
  this.coxaEsquerdaRelaxada,
  this.coxaEsquerdaContraida,
  this.panturrilhaDireita,
  this.panturrilhaEsquerda,
  this.bracoRelaxadoDireita,
  this.bracoContraidoDireita,
  this.bracoRelaxadoEsquerdo,
  this.bracoContraidoEsquerdo,
  this.antebracoDireito,
  this.antebracoEsquerdo,
  });

 Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'avalicaoId': avalicaoId, // 'uId' é o 'id' do usuário, que é o 'uId' do 'FirebaseAuth  
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
    avalicaoId: json['avalicaoId'] as String,
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
