import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo_premium/api/auth.dart';
import 'package:flutter/widgets.dart';

class PremiumProvider extends ChangeNotifier {
  final SettingsProvider _settings;
  List<String> get scopes => _settings.premiumScopes;
  bool hasScope(String scope) => scopes.contains(scope) || scopes.contains("filc.premium.*");
  String get accessToken => _settings.premiumAccessToken;
  bool get hasPremium => _settings.premiumAccessToken != "" && _settings.premiumScopes.isNotEmpty;

  late final PremiumAuth _auth;
  PremiumAuth get auth => _auth;

  PremiumProvider({required SettingsProvider settings}) : _settings = settings {
    _auth = PremiumAuth(settings: _settings);
    _settings.addListener(() {
      notifyListeners();
    });
  }

  Future<void> activate() async {
    await _auth.refreshAuth();
    notifyListeners();
  }
}
