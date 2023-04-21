import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../models/produits/produit_model.dart';
import '../../repository/repository.dart';

class ProduitsHandlers {
  final Repository repos;

  ProduitsHandlers(this.repos);

  Router get router {
    final router = Router();

    router.get('/', (Request request) async {
      List<ProduitModel> data = await repos.produits.getAllData();
      return Response.ok(jsonEncode(data));
    });

    router.get('/<id>', (Request request, String id) async {
      late ProduitModel data;
      try {
        data = await repos.produits.getFromId(int.parse(id));
      } catch (e) {
        print(e);
        return Response(404);
      }
      return Response.ok(jsonEncode(data.toJson()));
    });

    router.post('/insert-produit', (Request request) async {
      var input = jsonDecode(await request.readAsString());

      ProduitModel data = ProduitModel(
        produitName: input['produitName'],
        manager: input['manager'],
        signature: input['signature'],
        created: DateTime.parse(input['created']),
      );
      try {
        await repos.produits.insertData(data);
      } catch (e) {
        print(e);
        return Response(422);
      }
      return Response.ok(jsonEncode(data.toJson()));
    });

    router.put('/update-produit/', (Request request) async {
       dynamic input = jsonDecode(await request.readAsString());
      final editH = ProduitModel.fromJson(input);
      ProduitModel? data =
          await repos.produits.getFromId(editH.id!); 

      if (input['produitName'] != null) {
        data.produitName = input['produitName'];
      }
      if (input['manager'] != null) {
        data.manager = input['manager'];
      }
      if (input['signature'] != null) {
        data.signature = input['signature'];
      }
      if (input['created'] != null) {
        data.created = DateTime.parse(input['created']);
      }

      repos.produits.update(data);
      return Response.ok(jsonEncode(data.toJson()));
    });

    router.delete('/delete-produit/<id>', (Request request, String id) async {
      var id = request.params['id'];
      repos.produits.deleteData(int.parse(id!));
      return Response.ok('Supprimée');
    });

    router.all(
      '/<ignored|.*>',
      (Request request) =>
          Response.notFound('La Page produits n\'est pas trouvé'),
    );

    return router;
  }
}
