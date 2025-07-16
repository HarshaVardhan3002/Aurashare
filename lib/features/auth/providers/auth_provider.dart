import 'package:flutter/foundation.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/utils/logger.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider() {
    _checkAuthState();
  }

  void _checkAuthState() {
    _isAuthenticated = _firebaseService.isSignedIn;
    notifyListeners();
  }

  Future<void> signInAnonymously() async {
    _setLoading(true);
    _error = null;

    try {
      final user = await _firebaseService.signInAnonymously();
      _isAuthenticated = user != null;

      if (_isAuthenticated) {
        Logger.info('Anonymous authentication successful');
      } else {
        _error = 'Failed to authenticate anonymously';
      }
    } catch (e) {
      _error = e.toString();
      Logger.error('Anonymous authentication failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseService.signOut();
      _isAuthenticated = false;
      Logger.info('User signed out');
      notifyListeners();
    } catch (e) {
      Logger.error('Sign out failed: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
