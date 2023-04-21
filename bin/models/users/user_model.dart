class UserModel {
  late int? id;
  late String? photo;
  late String nom;
  late String prenom;
  late String email;
  late String telephone;
  late String adresse;
  late String username;
  late String role; // Acces user de SuperAdmin à Admin
  late String passwordHash;
  late String entreprise;
  late String manager;
  late String produits;
  late DateTime created;

  UserModel({
    this.id,
    this.photo,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
    required this.adresse,
    required this.username,
    required this.role,
    required this.passwordHash,
    required this.entreprise,
    required this.manager,
    required this.produits,
    required this.created,
  });

  factory UserModel.fromSQL(List<dynamic> row) {
    return UserModel(
      id: row[0],
      photo: row[1],
      nom: row[2],
      prenom: row[3],
      email: row[4],
      telephone: row[5],
      adresse: row[6],
      username: row[7],
      role: row[8],
      passwordHash: row[9],
      entreprise: row[10],
      manager: row[11],
      produits: row[12],
      created: row[13],
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      photo: json["photo"],
      nom: json["nom"],
      prenom: json["prenom"],
      email: json["email"],
      telephone: json["telephone"],
      adresse: json["adresse"],
      username: json["username"],
      role: json["role"],
      passwordHash: json["passwordHash"],
      entreprise: json["entreprise"],
      manager: json['manager'],
      produits: json['produits'],
      created: DateTime.parse(json["created"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'photo': photo,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'adresse': adresse,
      'username': username,
      'role': role,
      'passwordHash': passwordHash,
      'entreprise': entreprise,
      'manager': manager,
      'produits': produits,
      'created': created.toIso8601String(),
    };
  }
}
