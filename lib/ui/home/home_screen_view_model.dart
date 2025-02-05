import 'package:flutter/foundation.dart';
import 'package:throw_your_phone/data/services/google_login_service.dart';

class HomeScreenViewModel extends ChangeNotifier {
  final GoogleLoginService _loginService;

  HomeScreenViewModel({required GoogleLoginService loginService})
      : _loginService = loginService {
    _init();
  }

  _init() {
    loggedIn = _loginService.isAuthorized;
  }

  bool loggedIn = false;

  Future logIn() async {
    var result = await _loginService.login();
    loggedIn = result != null;
    notifyListeners();
    return Future.value(result);
  }

  Future logOut() async {
    var result = await _loginService.logout();
    loggedIn = result != null;
    notifyListeners();
    return Future.value(result);
  }
}
