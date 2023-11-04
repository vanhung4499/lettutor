import 'package:lettutor/app/core/usecases/param_usecase.dart';
import 'package:lettutor/domain/entities/user.dart';
import 'package:lettutor/domain/repositories/auth_repository.dart';
import 'package:tuple/tuple.dart';

class LoginUseCase extends ParamUseCase<User, Tuple2<String, String>> {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  @override
  Future<User> execute(Tuple2<String, String> params) {
    return _repository.register(params.item1, params.item2);
  }
}
