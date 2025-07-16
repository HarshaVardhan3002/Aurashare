import 'package:flutter/foundation.dart';
import '../../../core/services/photo_service.dart';
import '../../../data/models/photo_model.dart';

class GalleryProvider with ChangeNotifier {
  final PhotoService _photoService = PhotoService();

  List<Photo> _photos = [];
  bool _isLoading = false;
  String? _error;

  List<Photo> get photos => _photos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPhotos(String eventId) async {
    _setLoading(true);
    _error = null;

    try {
      _photos = await _photoService.getEventPhotos(eventId);
    } catch (e) {
      _error = 'Failed to load photos: $e';
    } finally {
      _setLoading(false);
    }
  }

  void addPhoto(Photo photo) {
    _photos.insert(0, photo); // Add to beginning for newest first
    notifyListeners();
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
