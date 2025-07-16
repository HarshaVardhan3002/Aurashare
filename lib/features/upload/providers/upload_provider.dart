import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../../core/services/photo_service.dart';

class UploadProvider with ChangeNotifier {
  final PhotoService _photoService = PhotoService();

  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String? _error;

  bool get isUploading => _isUploading;
  double get uploadProgress => _uploadProgress;
  String? get error => _error;

  Future<bool> uploadPhotos({
    required String eventId,
    required List<File> images,
    String? uploaderNickname,
  }) async {
    if (images.isEmpty) return false;

    _setUploading(true);
    _error = null;

    int successCount = 0;
    int totalImages = images.length;

    try {
      for (int i = 0; i < images.length; i++) {
        final image = images[i];

        // Update progress
        _uploadProgress = (i / totalImages);
        notifyListeners();

        final photo = await _photoService.uploadPhoto(
          eventId: eventId,
          imageFile: image,
          uploaderNickname: uploaderNickname,
        );

        if (photo != null) {
          successCount++;
        }
      }

      _uploadProgress = 1.0;
      notifyListeners();

      if (successCount == 0) {
        _error = 'Failed to upload any photos';
        return false;
      } else if (successCount < totalImages) {
        _error =
            'Some photos failed to upload ($successCount/$totalImages successful)';
      }

      return successCount > 0;
    } catch (e) {
      _error = 'Upload failed: $e';
      return false;
    } finally {
      _setUploading(false);
    }
  }

  void _setUploading(bool uploading) {
    _isUploading = uploading;
    if (!uploading) {
      _uploadProgress = 0.0;
    }
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
