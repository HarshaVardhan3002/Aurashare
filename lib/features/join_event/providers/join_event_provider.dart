import 'package:flutter/foundation.dart';
import '../../../core/services/event_service.dart';
import '../../../data/models/event_model.dart';

class JoinEventProvider with ChangeNotifier {
  final EventService _eventService = EventService();

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<Event?> joinEventByPin(String pin, {String? nickname}) async {
    _setLoading(true);
    _error = null;

    try {
      final event = await _eventService.joinEventByPin(pin, nickname: nickname);
      if (event == null) {
        _error = 'Event not found or expired';
      }
      return event;
    } catch (e) {
      _error = 'Failed to join event: $e';
      return null;
    } finally {
      _setLoading(false);
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
