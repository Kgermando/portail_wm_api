class ProduitModel {
  late int? id;
  late String produitName;
  late String manager;
  late String signature;
  late DateTime created;
 
  ProduitModel({
    this.id,
    required this.produitName,
    required this.manager,
    required this.signature,
    required this.created,
  });

  factory ProduitModel.fromSQL(List<dynamic> row) {
    return ProduitModel(
      id: row[0],
      produitName: row[1],
      manager: row[2],
      signature: row[3],
      created: row[4],
    );
  }

  factory ProduitModel.fromJson(Map<String, dynamic> json) {
    return ProduitModel(
      id: json['id'],
      produitName: json['produitName'],
      manager: json['manager'],
      signature: json['signature'],
      created: DateTime.parse(json['created']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'produitName': produitName,
      'manager': manager,
      'signature': signature,
      'created': created.toIso8601String(),
    };
  }
}
