import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:throw_your_phone/data/services/google_login_service.dart';

class SupabaseService {
  SupabaseService({required GoogleLoginService googleLoginService})
      : _googleLoginService = googleLoginService {
    _init();
  }

  final GoogleLoginService _googleLoginService;

  static const String supabaseUrl = "https://hwjwxjeczyyktpzpmcxj.supabase.co";
  static const String apiKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh3and4amVjenl5a3RwenBtY3hqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg3NTQyNjcsImV4cCI6MjA1NDMzMDI2N30.1V3htEnLXU5as2edWXmdIfF6BceYuvdE47iTZYU6O_4";

  Future login() async {
    await _googleLoginService.login();
    return loginSilently();
  }

  Future loginSilently() async {
    final supabase = Supabase.instance.client;
    if (supabase.auth.currentSession != null &&
        !supabase.auth.currentSession!.isExpired) {
      return;
    }

    var credentials = await _googleLoginService.getSignInCredentials();
    if (credentials == null) {
      return;
    }
    final auth = await credentials.authentication;
    final accessToken = auth.accessToken;
    final idToken = auth.idToken;
    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }
    final response = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
    if (response.session != null) {}
  }

  bool loggedIn() {
    final supabase = Supabase.instance.client;
    return supabase.auth.currentSession != null &&
        !supabase.auth.currentSession!.isExpired;
  }

  Future _init() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: apiKey,
    );
    await loginSilently();
  }
}
