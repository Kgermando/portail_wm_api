import 'package:postgres/postgres.dart';

import '../../models/clients/client_model.dart';

class ClientRepository {
  final PostgreSQLConnection executor;
  final String tableName;

  ClientRepository(this.executor, this.tableName);

  Future<List<ClientModel>> getAllData() async {
    var data = <ClientModel>{};

    var querySQL = "SELECT * FROM $tableName ORDER BY \"created\" DESC;";
    List<List<dynamic>> results = await executor.query(querySQL);
    for (var row in results) {
      data.add(ClientModel.fromSQL(row));
    }
    return data.toList();
  }

  Future<void> insertData(ClientModel data) async {
    await executor.transaction((ctx) async {
      await ctx.query(
        "INSERT INTO $tableName (id, type, business_name, logo_url, name_client,"
        "rccm, n_impot, id_nat, email, telephone, telephone_2, adresse, statut,"
        "montant, produits, entreprise, signature, created)"
        "VALUES (nextval('clients_id_seq'), @1, @2, @3, @4, @5, @6, @7, @8, @9,"
        "@10, @11, @12, @13, @14, @15, @16, @17)",
        substitutionValues: {
          '1': data.type,
          '2': data.businessName,
          '3': data.logoUrl,
          '4': data.nameClient,
          '5': data.rccm,
          '6': data.nImpot,
          '7': data.idNat,
          '8': data.email,
          '9': data.telephone,
          '10': data.telephone2,
          '11': data.adresse,
          '12': data.statut,
          '13': data.montant,
          '14': data.produits,
          '15': data.entreprise,
          '16': data.signature,
          '17': data.created, 
        });
    });
  }

  Future<void> update(ClientModel data) async {
    await executor.query("""UPDATE $tableName
      SET type = @1, business_name = @2, logo_url = @3, name_client = @4, 
      rccm = @5, n_impot = @6, id_nat = @7, email = @8, telephone = @9, 
      telephone_2 = @10, adresse = @11, statut = @12, montant = @13, produits = @14, entreprise = @15,
      signature = @16, created = @17 WHERE id = @18""",
        substitutionValues: {
          '1': data.type,
          '2': data.businessName,
          '3': data.logoUrl,
          '4': data.nameClient,
          '5': data.rccm,
          '6': data.nImpot,
          '7': data.idNat,
          '8': data.email,
          '9': data.telephone,
          '10': data.telephone2,
          '11': data.adresse,
          '12': data.statut,
          '13': data.montant,
          '14': data.produits,
          '15': data.entreprise,
          '16': data.signature,
          '17': data.created, 
          '18': data.id
        });
  }

  deleteData(int id) async {
    try {
      await executor.transaction((conn) async {
        // ignore: unused_local_variable
        var result = await conn.execute('DELETE FROM $tableName WHERE id=$id;');
      });
    } catch (e) {
      'erreur $e';
    }
  }

  Future<ClientModel> getFromId(int id) async {
    var data =
        await executor.query("SELECT * FROM  $tableName WHERE \"id\" = '$id'");
    return ClientModel(
      id: data[0][0],
      type: data[0][1],
      businessName: data[0][2],
      logoUrl: data[0][3],
      nameClient: data[0][4],
      rccm: data[0][5],
      nImpot: data[0][6],
      idNat: data[0][7],
      email: data[0][8],
      telephone: data[0][9],
      telephone2: data[0][10],
      adresse: data[0][11],
      statut: data[0][12],
      montant: data[0][13],
      produits: data[0][14],
      entreprise: data[0][15],
      signature: data[0][16],
      created: data[0][17],
    );
  }
}
