class EntrepriseModel {
  late int? id;
  late String entrepriseName;
  late String logoUrl;
  late String manager;
  late String email;
  late String telephone;
  late String adresse;
  late String signature;
  late DateTime created;

  EntrepriseModel({
    this.id,
    required this.entrepriseName,
    required this.logoUrl,
    required this.manager,
    required this.email,
    required this.telephone,
    required this.adresse,
    required this.signature,
    required this.created,
  });

  factory EntrepriseModel.fromSQL(List<dynamic> row) {
    return EntrepriseModel(
      id: row[0],
      entrepriseName: row[1],
      logoUrl: row[2],
      manager: row[3],
      email: row[4],
      telephone: row[5],
      adresse: row[6],
      signature: row[7],
      created: row[8],
    );
  }

  factory EntrepriseModel.fromJson(Map<String, dynamic> json) {
    return EntrepriseModel(
      id: json['id'],
      entrepriseName: json['entrepriseName'],
      logoUrl: json['logoUrl'],
      manager: json['manager'],
      email: json['email'],
      telephone: json['telephone'],
      adresse: json['adresse'],
      signature: json['signature'],
      created: DateTime.parse(json['created']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entrepriseName': entrepriseName,
      'logoUrl': logoUrl,
      'manager': manager,
      'email': email,
      'telephone': telephone,
      'adresse': adresse,
      'signature': signature,
      'created': created.toIso8601String(),
    };
  }
}
