import '../../models/user_model.dart';

abstract class AuthenticationRemoteDatasource {
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  Future<List<UserModel>> getUsers();
}