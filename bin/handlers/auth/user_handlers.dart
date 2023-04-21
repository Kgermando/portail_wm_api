import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart';

import '../../models/users/user_model.dart';
import '../../repository/repository.dart';

class UserHandlers {
  final Repository repos;
  UserHandlers(this.repos);

  Router get router {
    final router = Router();

    // Get all users
    router.get('/users/', (Request request) async {
      List<UserModel> data = await repos.users.getAllData();
      return Response.ok(jsonEncode(data));
    });

    router.get('/', (Request request) async {
      UserModel selectUser =
          await repos.users.getFromId(request.context['id'] as int);
      return Response.ok(jsonEncode(selectUser.toJson()));
    });

    router.get('/<id>', (Request request, String id) async {
      late UserModel selectUser;
      try {
        selectUser = await repos.users.getFromId(int.parse(id));
      } catch (e) {
        print(e);
        return Response(404);
      }
      return Response.ok(jsonEncode(selectUser.toJson()));
    });

    // Add new user
    router.post('/insert-new-user', (Request request) async {
      var input = jsonDecode(await request.readAsString());
      UserModel agent = UserModel(
        photo: input['photo'],
        nom: input['nom'],
        prenom: input['prenom'],
        email: input['email'],
        telephone: input['telephone'],
        adresse: input['adresse'],
        username: input['username'],
        role: input['role'],
        passwordHash:
            md5.convert(utf8.encode(input['passwordHash'])).toString(),
        entreprise: input['entreprise'],
        manager: input['manager'],
        produits: input['produits'],
        created: DateTime.parse(input['created']),
      );
      try {
        await repos.users.insertData(agent);
      } catch (e) {
        print(e);
        return Response(422);
      }
      return Response.ok(jsonEncode(agent.toJson()));
    });

    router.put('/update-user/', (Request request) async {
      dynamic input = jsonDecode(await request.readAsString());
      final editH = UserModel.fromJson(input);
      UserModel? selectUser = await repos.users.getFromId(editH.id!);

      if (input['photo'] != null) {
        selectUser.photo = input['photo'];
      }
      if (input['nom'] != null) {
        selectUser.nom = input['nom'];
      }
      if (input['prenom'] != null) {
        selectUser.prenom = input['prenom'];
      }
      if (input['email'] != null) {
        selectUser.email = input['email'];
      }
      if (input['telephone'] != null) {
        selectUser.telephone = input['telephone'];
      }
      if (input['adresse'] != null) {
        selectUser.adresse = input['adresse'];
      }
      // if (input['username'] != null) {
      //   selectUser.username = input['username'];
      // }
      if (input['role'] != null) {
        selectUser.role = input['role'];
      }
      if (input['entreprise'] != null) {
        selectUser.entreprise = input['entreprise'];
      }
      if (input['manager'] != null) {
        selectUser.manager = input['manager'];
      }
      if (input['produits'] != null) {
        selectUser.produits = input['produits'];
      }
      repos.users.update(selectUser);
      return Response.ok(jsonEncode(selectUser.toJson()));
    });

    router.put('/change-password/', (Request request) async {
      dynamic input = jsonDecode(await request.readAsString());
      final editH = UserModel.fromJson(input);
      UserModel? selectUser = await repos.users.getFromId(editH.id!);

      // Check si le mot de passe par defaut est correct
      if (input['passwordHash'] != null) {
        selectUser.passwordHash =
            md5.convert(utf8.encode(input['passwordHash'])).toString();
      }
      repos.users.update(selectUser);
      return Response.ok(jsonEncode(selectUser.toJson()));
    });

    router.delete('/delete-user/<id>', (Request request, String id) async {
      var id = request.params['id'];
      repos.users.deleteData(int.parse(id!));
      return Response.ok('Agent supprimée');
    });

    router.all(
      '/<ignored|.*>',
      (Request request) => Response.notFound('La Page user n\'est pas trouvé'),
    );

    return router;
  }
}
