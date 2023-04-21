import 'package:postgres/postgres.dart';

import '../../models/produits/produit_model.dart';

class ProduitRepository {
  final PostgreSQLConnection executor;
  final String tableName;

  ProduitRepository(this.executor, this.tableName);

  Future<List<ProduitModel>> getAllData() async {
    var data = <ProduitModel>{};

    var querySQL = "SELECT * FROM $tableName ORDER BY \"created\" DESC;";
    List<List<dynamic>> results = await executor.query(querySQL);
    for (var row in results) {
      data.add(ProduitModel.fromSQL(row));
    }
    return data.toList();
  }

  Future<void> insertData(ProduitModel data) async {
    await executor.transaction((ctx) async {
      await ctx.query(
          "INSERT INTO $tableName (id, produit_name, manager, signature, created)"
          "VALUES (nextval('produits_id_seq'), @1, @2, @3, @4)",
          substitutionValues: {
            '1': data.produitName,
            '2': data.manager,
            '3': data.signature,
            '4': data.created,
          });
    });
  }

  Future<void> update(ProduitModel data) async {
    await executor.query("""UPDATE $tableName
      SET produit_name = @1, manager = @2, signature = @3, created = @4 WHERE id = @5""",
        substitutionValues: {
          '1': data.produitName,
          '2': data.manager,
          '3': data.signature,
          '4': data.created,
          '5': data.id
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

  Future<ProduitModel> getFromId(int id) async {
    var data =
        await executor.query("SELECT * FROM  $tableName WHERE \"id\" = '$id'");
    return ProduitModel(
      id: data[0][0],
      produitName: data[0][1],
      manager: data[0][2],
      signature: data[0][3],
      created: data[0][4],
    );
  }
}
