class ClientModel {
  late int? id;
  late String type; // Entreprise ou particulier
  late String businessName; // Le nom de son travail Ex: Dieu le veut
  late String logoUrl;
  late String nameClient;
  late String rccm;
  late String nImpot;
  late String idNat;
  late String email;
  late String telephone;
  late String telephone2;
  late String adresse;
  late String statut; // Actif ou inactif
  late String montant; // Abonnement
  late String produits;
  late String entreprise;
  late String signature;
  late DateTime created;

  ClientModel({
    this.id,
    required this.type,
    required this.businessName,
    required this.logoUrl,
    required this.nameClient,
    required this.rccm,
    required this.nImpot,
    required this.idNat,
    required this.email,
    required this.telephone,
    required this.telephone2,
    required this.adresse,
    required this.statut,
    required this.montant,
    required this.produits,
    required this.entreprise,
    required this.signature,
    required this.created,
  });

  factory ClientModel.fromSQL(List<dynamic> row) {
    return ClientModel(
      id: row[0],
      type: row[1],
      businessName: row[2],
      logoUrl: row[3],
      nameClient: row[4],
      rccm: row[5],
      nImpot: row[6],
      idNat: row[7],
      email: row[8],
      telephone: row[9],
      telephone2: row[10],
      adresse: row[11],
      statut: row[12],
      montant: row[13],
      produits: row[14],
      entreprise: row[15],
      signature: row[16],
      created: row[17],
    );
  }

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'],
      type: json['type'],
      businessName: json['businessName'],
      logoUrl: json['logoUrl'],
      nameClient: json['nameClient'],
      rccm: json['rccm'],
      nImpot: json['nImpot'],
      idNat: json['idNat'],
      email: json['email'],
      telephone: json['telephone'],
      telephone2: json['telephone2'],
      adresse: json['adresse'],
      statut: json['statut'],
      montant: json['montant'],
      produits: json['produits'],
      entreprise: json['entreprise'],
      signature: json['signature'],
      created: DateTime.parse(json['created']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'businessName': businessName,
      'logoUrl': logoUrl,
      'nameClient': nameClient,
      'rccm': rccm,
      'nImpot': nImpot,
      'idNat': idNat,
      'email': email,
      'telephone': telephone,
      'telephone2': telephone2,
      'adresse': adresse,
      'statut': statut,
      'montant': montant,
      'produits': produits,
      'entreprise': entreprise,
      'signature': signature,
      'created': created.toIso8601String(),
    };
  }
}
