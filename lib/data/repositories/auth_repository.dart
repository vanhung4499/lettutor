import 'package:lettutor/domain/entities/user.dart';
import 'package:lettutor/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<User> register(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return User(email: email, password: password);
  }

  @override
  Future<User> forgotPassword(String email) {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<User> login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<User> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<User> resetPassword(String pasword, String token) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }
}
