import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'db/config_db.dart';  
import 'handlers/auth/auth_handlers.dart';
import 'handlers/auth/user_handlers.dart';
import 'handlers/clients/client_handlers.dart';
import 'handlers/entreprise/entreprise_handlers.dart';
import 'handlers/produits/produits_handlers.dart';
import 'middleware/middleware.dart';
import 'repository/repository.dart';

// Configure routes.
class Service {
  final Repository repos;
  final String serverSecretKey;

  Service(this.repos, this.serverSecretKey);

  Handler get handlers {
    final router = Router();

        // AUTH
    router.mount(
        '/api/auth/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            .addHandler(AuthHandlers(repos, serverSecretKey).router));
    router.mount(
        '/api/user/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(UserHandlers(repos).router));

      router.mount(
        '/api/clients/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            .addHandler(ClientHandlers(repos).router));
    router.mount(
      '/api/entreprises/',
      Pipeline()
          .addMiddleware(setJsonHeader())
          .addMiddleware(handleErrors())
          .addHandler(EntrepriseHandlers(repos).router));
    router.mount(
        '/api/produits/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            .addHandler(ProduitsHandlers(repos).router));

 
    router.all(
      '/<ignored|.*>',
      (Request request) => Response.notFound(null),
    );
    return router;
  }
}


void main(List<String> args) async {
  final ip = "app";
  final port = 80;

  PostgreSQLConnection connection = await ConnexionDatabase().connection();
  print("Database it's work...");

  await connection.open();
  Repository repos = Repository(connection);
  Service service = Service(repos, "work_management_Key");

  final server = await shelf_io.serve(service.handlers, ip, port);

  print('Server listening on port ${server.port}');
}
