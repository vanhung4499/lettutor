import 'package:dart_either/dart_either.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:lettutor/core/network/app_exception.dart';
import 'package:lettutor/data/models/common/app_error.dart';

@injectable
class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
    "450036471337-ke0gj573jo7m1gmjtgimndfvdgti2gjt.apps.googleusercontent.com",
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  SingleResult<String?> getGoogleAccessToken() => SingleResult.fromCallable(() async {
    final googleSignInAccount = await _googleSignIn.signIn();
    if (googleSignInAccount == null) {
      return Either.left(AppException(message: 'Google sign in error'));
    }

    String? accessToken = "";
    await googleSignInAccount.authentication.then((account) {
      accessToken = account.accessToken;
    });

    return Either.right(accessToken);
  });
}
