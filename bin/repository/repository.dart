import 'package:postgres/postgres.dart';

import 'clients/client_repository.dart';
import 'entreprise/entreprise_repository.dart';
import 'produits/produits_repository.dart';
import 'user/refresh_token_repository.dart';
import 'user/user_repository.dart';
  
class Repository {
  final PostgreSQLConnection executor;
  
  late RefreshTokensRepository refreshTokens;
  late UserRepository users;

  late ClientRepository clients;
  late EntrepriseRepository entreprises;
  late ProduitRepository produits;

  Repository(this.executor) { 
    // AUTH
    refreshTokens = RefreshTokensRepository(executor, 'refresh_tokens');
    users = UserRepository(executor, 'users');

    clients = ClientRepository(executor, 'clients');
    entreprises = EntrepriseRepository(executor, 'entreprises');
    produits = ProduitRepository(executor, 'produits');

  
  }
}
