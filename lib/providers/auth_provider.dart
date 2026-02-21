import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';


// Authentication provider managing user login state and token persistence
// Fields: - _token: stores the authentication token after successful login
//         - _username: stores the username of the logged-in user
//         - isLoading: indicates if a login or registration process is ongoing
//         - error: holds any error message from login or registration attempts
// Methods: - login: handles user login, saves token and username on success
//          - register: handles user registration, returns success status
//          - logout: clears authentication data and notifies listeners
//          - token: getter for the authentication token
//          - username: getter for the current username
class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  String? _token;
  String? _username;
  bool isLoading = false;
  String? error;

  bool get isAuthenticated => _token != null;

  Future<bool> login(String username, String password) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final token = await _service.login(username, password);
      _token = token;
      _username = username;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('auth_username', username);

      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String username, String password) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await _service.register(username, password);
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _token = null;
    _username = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_username');
    // Note: registered_users list is kept for future logins
    notifyListeners();
  }

  String? get token => _token;
  String? get username => _username;
}
