import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../models/clients/client_model.dart';
import '../../repository/repository.dart';

class ClientHandlers {
  final Repository repos;

  ClientHandlers(this.repos);

  Router get router {
    final router = Router();

    router.get('/', (Request request) async {
      List<ClientModel> data = await repos.clients.getAllData();
      return Response.ok(jsonEncode(data));
    });

    router.get('/<id>', (Request request, String id) async {
      late ClientModel data;
      try {
        data = await repos.clients.getFromId(int.parse(id));
      } catch (e) {
        print(e);
        return Response(404);
      }
      return Response.ok(jsonEncode(data.toJson()));
    });

    router.post('/insert-client', (Request request) async {
      var input = jsonDecode(await request.readAsString());

      ClientModel data = ClientModel(
        type: input['type'],
        businessName: input['businessName'],
        logoUrl: input['logoUrl'],
        nameClient: input['nameClient'],
        rccm: input['rccm'],
        nImpot: input['nImpot'],
        idNat: input['idNat'],
        email: input['email'],
        telephone: input['telephone'],
        telephone2: input['telephone2'],
        adresse: input['adresse'],
        statut: input['statut'],
        montant: input['montant'],
        produits: input['produits'],
        entreprise: input['entreprise'],
        signature: input['signature'],
        created: DateTime.parse(input['created']),
      );
      try {
        await repos.clients.insertData(data);
      } catch (e) {
        print(e);
        return Response(422);
      }
      return Response.ok(jsonEncode(data.toJson()));
    });

    router.put('/update-client/', (Request request) async {
       dynamic input = jsonDecode(await request.readAsString());
      final editH = ClientModel.fromJson(input);
      ClientModel? data =
          await repos.clients.getFromId(editH.id!); 

      if (input['type'] != null) {
        data.type = input['type'];
      }
      if (input['businessName'] != null) {
        data.businessName = input['businessName'];
      }
      if (input['logoUrl'] != null) {
        data.logoUrl = input['logoUrl'];
      }
      if (input['nameClient'] != null) {
        data.nameClient = input['nameClient'];
      }
      if (input['rccm'] != null) {
        data.rccm = input['rccm'];
      }
      if (input['nImpot'] != null) {
        data.nImpot = input['nImpot'];
      }
      if (input['idNat'] != null) {
        data.idNat = input['idNat'];
      }
      if (input['email'] != null) {
        data.email = input['email'];
      }
      if (input['telephone'] != null) {
        data.telephone = input['telephone'];
      }
      if (input['telephone2'] != null) {
        data.telephone2 = input['telephone2'];
      }
      if (input['adresse'] != null) {
        data.adresse = input['adresse'];
      }
      if (input['statut'] != null) {
        data.statut = input['statut'];
      }
      if (input['montant'] != null) {
        data.montant = input['montant'];
      }
      if (input['produits'] != null) {
        data.produits = input['produits'];
      }
      if (input['entreprise'] != null) {
        data.entreprise = input['entreprise'];
      }
      if (input['signature'] != null) {
        data.signature = input['signature'];
      }
      if (input['created'] != null) {
        data.created = DateTime.parse(input['created']);
      }

      repos.clients.update(data);
      return Response.ok(jsonEncode(data.toJson()));
    });

    router.delete('/delete-client/<id>', (Request request, String id) async {
      var id = request.params['id'];
      repos.clients.deleteData(int.parse(id!));
      return Response.ok('Supprimée');
    });

    router.all(
      '/<ignored|.*>',
      (Request request) =>
          Response.notFound('La Page clients n\'est pas trouvé'),
    );

    return router;
  }
}
