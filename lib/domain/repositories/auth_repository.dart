import 'package:lettutor/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> register(String email, String password);
  Future<User> login(String email, String password);
  Future<User> forgotPassword(String email);
  Future<User> resetPassword(String pasword, String token);
  Future<User> logout();
}
