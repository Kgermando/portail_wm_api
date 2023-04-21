import 'package:postgres/postgres.dart';

import '../../models/entreprise/entreprise_model.dart';

class EntrepriseRepository {
  final PostgreSQLConnection executor;
  final String tableName;

  EntrepriseRepository(this.executor, this.tableName);

  Future<List<EntrepriseModel>> getAllData() async {
    var data = <EntrepriseModel>{};

    var querySQL = "SELECT * FROM $tableName ORDER BY \"created\" DESC;";
    List<List<dynamic>> results = await executor.query(querySQL);
    for (var row in results) {
      data.add(EntrepriseModel.fromSQL(row));
    }
    return data.toList();
  }

  Future<void> insertData(EntrepriseModel data) async {
    await executor.transaction((ctx) async {
      await ctx.query(
          "INSERT INTO $tableName (id, entreprise_name, logo_url,"
          "manager, email, telephone, adresse, signature, created)"
          "VALUES (nextval('entreprises_id_seq'), @1, @2, @3, @4, @5, @6, @7, @8)",
          substitutionValues: {
            '1': data.entrepriseName,
            '2': data.logoUrl,
            '3': data.manager,
            '4': data.email,
            '5': data.telephone,
            '6': data.adresse,
            '7': data.signature,
            '8': data.created
          });
    });
  }

  Future<void> update(EntrepriseModel data) async {
    await executor.query("""UPDATE $tableName
      SET entreprise_name = @1, logo_url = @2, manager = @3, email = @4,
      telephone = @5, adresse = @6, signature = @7, created = @8 WHERE id = @9""",
        substitutionValues: {
          '1': data.entrepriseName,
          '2': data.logoUrl,
          '3': data.manager,
          '4': data.email,
          '5': data.telephone,
          '6': data.adresse,
          '7': data.signature,
          '8': data.created,
          '9': data.id
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

  Future<EntrepriseModel> getFromId(int id) async {
    var data =
        await executor.query("SELECT * FROM  $tableName WHERE \"id\" = '$id'");
    return EntrepriseModel(
      id: data[0][0],
      entrepriseName: data[0][1],
      logoUrl: data[0][2],
      manager: data[0][3],
      email: data[0][4],
      telephone: data[0][5],
      adresse: data[0][6],
      signature: data[0][7],
      created: data[0][8]
    );
  }
}
