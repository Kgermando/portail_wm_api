import 'package:postgres/postgres.dart';

import '../../models/users/user_model.dart';

class UserRepository {
  final PostgreSQLConnection executor;
  final String tableName;

  UserRepository(this.executor, this.tableName);

  Future<bool> isUniqueLogin(String username) async {
    var data = await executor
        .query("SELECT * FROM  $tableName WHERE \"username\" = '$username'");
    return data.isEmpty ? true : data[0].isEmpty;
  }

  Future<int> getIdFromLoginPassword(
      String username, String passwordHash) async {
    var data = await executor.query(
        "SELECT id FROM $tableName WHERE \"username\"='$username' AND \"password_hash\"='$passwordHash'");
    return data[0][0];
  }

  Future<List<UserModel>> getAllData() async {
    var data = <UserModel>{};

    var querySQL = "SELECT * FROM $tableName ORDER BY \"created_at\" DESC;";
    List<List<dynamic>> results = await executor.query(querySQL);
    for (var row in results) {
      data.add(UserModel.fromSQL(row));
    }
    return data.toList();
  }

  Future<void> insertData(UserModel data) async {
    await executor.transaction((ctx) async {
      await ctx.execute(
          "INSERT INTO $tableName (id, photo, nom, prenom, email, telephone, adresse,"
          "username, role, password_hash, entreprise, manager, produits, created)"
          "VALUES (nextval('users_id_seq'), @1, @2, @3, @4, @5, @6, @7,"
          "@8, @9, @10, @11, @12, @13)",
          substitutionValues: {
            '1': data.photo,
            '2': data.nom,
            '3': data.prenom,
            '4': data.email,
            '5': data.telephone,
            '6': data.adresse,
            '7': data.username,
            '8': data.role,
            '9': data.passwordHash,
            '10': data.entreprise,
            '11': data.manager,
            '12': data.produits,
            '13': data.created,
          });
    });
  }

  Future<void> update(UserModel data) async {
    await executor.execute("""UPDATE $tableName
      SET photo = @1, nom = @2, prenom = @3, email = @4, telephone = @5, adresse = @6,
      username = @7, role = @8, password_hash = @9, entreprise = @10,
      manager = @11, produits = @12, created = @13 WHERE id = @14""",
        substitutionValues: {
          '1': data.photo,
          '2': data.nom,
          '3': data.prenom,
          '4': data.email,
          '5': data.telephone,
          '6': data.adresse,
          '7': data.username,
          '8': data.role,
          '9': data.passwordHash,
          '10': data.entreprise,
          '11': data.manager,
          '12': data.produits,
          '13': data.created,
          '14': data.id
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

  Future<UserModel> getFromId(int id) async {
    var data =
        await executor.query("SELECT * FROM  $tableName WHERE \"id\"='$id'");
    return UserModel(
      id: data[0][0],
      photo: data[0][1],
      nom: data[0][2],
      prenom: data[0][3],
      email: data[0][4],
      telephone: data[0][5],
      adresse: data[0][6],
      username: data[0][7],
      role: data[0][8],
      passwordHash: data[0][9],
      entreprise: data[0][10],
      manager: data[0][11],
      produits: data[0][12],
      created: data[0][13],
    );
  }
}
