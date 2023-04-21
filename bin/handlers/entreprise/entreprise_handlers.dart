import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../models/entreprise/entreprise_model.dart';
import '../../repository/repository.dart';

class EntrepriseHandlers {
  final Repository repos;

  EntrepriseHandlers(this.repos);

  Router get router {
    final router = Router();

    router.get('/', (Request request) async {
      List<EntrepriseModel> data = await repos.entreprises.getAllData();
      return Response.ok(jsonEncode(data));
    });

    router.get('/<id>', (Request request, String id) async {
      late EntrepriseModel data;
      try {
        data = await repos.entreprises.getFromId(int.parse(id));
      } catch (e) {
        print(e);
        return Response(404);
      }
      return Response.ok(jsonEncode(data.toJson()));
    });

    router.post('/insert-entreprise', (Request request) async {
      var input = jsonDecode(await request.readAsString());

      EntrepriseModel data = EntrepriseModel(
        entrepriseName: input['entrepriseName'],
        logoUrl: input['logoUrl'],
        manager: input['manager'],
        email: input['email'],
        telephone: input['telephone'], 
        adresse: input['adresse'], 
        signature: input['signature'],
        created: DateTime.parse(input['created']),
      );
      try {
        await repos.entreprises.insertData(data);
      } catch (e) {
        print(e);
        return Response(422);
      }
      return Response.ok(jsonEncode(data.toJson()));
    });

    router.put('/update-entreprise/', (Request request) async {
       dynamic input = jsonDecode(await request.readAsString());
      final editH = EntrepriseModel.fromJson(input);
      EntrepriseModel? data =
          await repos.entreprises.getFromId(editH.id!); 

      if (input['entrepriseName'] != null) {
        data.entrepriseName = input['entrepriseName'];
      }
      if (input['logoUrl'] != null) {
        data.logoUrl = input['logoUrl'];
      }
      if (input['manager'] != null) {
        data.manager = input['manager'];
      }
      if (input['email'] != null) {
        data.email = input['email'];
      }
      if (input['telephone'] != null) {
        data.telephone = input['telephone'];
      }
      if (input['adresse'] != null) {
        data.adresse = input['adresse'];
      }
      if (input['signature'] != null) {
        data.signature = input['signature'];
      }
      if (input['created'] != null) {
        data.created = DateTime.parse(input['created']);
      } 

      repos.entreprises.update(data);
      return Response.ok(jsonEncode(data.toJson()));
    });

    router.delete('/delete-entreprise/<id>', (Request request, String id) async {
      var id = request.params['id'];
      repos.entreprises.deleteData(int.parse(id!));
      return Response.ok('Supprimée');
    });

    router.all(
      '/<ignored|.*>',
      (Request request) =>
          Response.notFound('La Page entreprises n\'est pas trouvé'),
    );

    return router;
  }
}
