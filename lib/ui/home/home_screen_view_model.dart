import 'package:flutter/foundation.dart';
import 'package:throw_your_phone/data/services/google_login_service.dart';
import 'package:throw_your_phone/data/services/supabase_service.dart';

class HomeScreenViewModel extends ChangeNotifier {
  final GoogleLoginService _loginService;
  final SupabaseService _supabaseService;

  HomeScreenViewModel(
      {required GoogleLoginService loginService,
      required SupabaseService supabaseService})
      : _loginService = loginService,
        _supabaseService = supabaseService {
    _init();
  }

  _init() {
    loggedIn = _loginService.isAuthorized;
  }

  bool loggedIn = false;

  Future logIn() async {
    var result = await _loginService.login();
    await _supabaseService.login();
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
