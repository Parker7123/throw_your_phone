import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginService {
  static const String _webClientId =
      '1057839963123-cng4srblk151o95u5g2osmrdnspmr41i.apps.googleusercontent.com';
  static const _iosClientId =
      '1057839963123-sr2ntd80q9lp27870j46surmtslidc08.apps.googleusercontent.com';
  final GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _currentUser;
  bool isAuthorized = false;

  GoogleLoginService()
      : _googleSignIn = GoogleSignIn(
            clientId: _iosClientId,
            serverClientId: _webClientId,
            scopes: ['email']) {
    _init();
  }

  Future _init() async {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      isAuthorized = account != null;
      _currentUser = account;
    });
    await _googleSignIn.signInSilently();
  }

  Future<GoogleSignInAccount?> login() {
    return _googleSignIn.signIn();
  }

  Future<GoogleSignInAccount?> logout() {
    return _googleSignIn.signOut();
  }

  Future<GoogleSignInAccount?> getSignInCredentials() async {
    if (_currentUser != null) {
      return _currentUser;
    }
    _currentUser = await _googleSignIn.signInSilently();
    return _currentUser;
  }
}
