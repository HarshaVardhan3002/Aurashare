import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/photo_model.dart';
import 'firebase_service.dart';
import '../utils/logger.dart';

class PhotoService {
  static final PhotoService _instance = PhotoService._internal();
  factory PhotoService() => _instance;
  PhotoService._internal();

  final FirebaseService _firebase = FirebaseService();
  final Uuid _uuid = const Uuid();

  // Upload photo to Firebase Storage
  Future<Photo?> uploadPhoto({
    required String eventId,
    required File imageFile,
    String? uploaderNickname,
  }) async {
    try {
      final user = _firebase.currentUser;
      if (user == null) {
        Logger.error('User not authenticated');
        return null;
      }

      final photoId = _uuid.v4();
      final fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload to Firebase Storage
      final storageRef = _firebase.getPhotoStorageRef(eventId, photoId);
      final uploadTask = storageRef.putFile(imageFile);

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Create photo model
      final photo = Photo(
        id: photoId,
        eventId: eventId,
        uploaderId: user.uid,
        uploaderNickname: uploaderNickname,
        fileName: fileName,
        storageUrl: downloadUrl,
        uploadedAt: DateTime.now(),
        fileSize: await imageFile.length(),
        isUploaded: true,
      );

      // Save to Firestore
      await _firebase.photosCollection.doc(photoId).set(photo.toMap());

      // Update event photo count
      await _firebase.eventsCollection.doc(eventId).update({
        'photoCount': FieldValue.increment(1),
      });

      Logger.info('Photo uploaded successfully: $photoId');
      return photo;
    } catch (e) {
      Logger.error('Failed to upload photo: $e');
      return null;
    }
  }

  // Get all photos for an event
  Future<List<Photo>> getEventPhotos(String eventId) async {
    try {
      final querySnapshot = await _firebase.photosCollection
          .where('eventId', isEqualTo: eventId)
          .orderBy('uploadedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Photo.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Logger.error('Failed to get event photos: $e');
      return [];
    }
  }

  // Stream photos for real-time updates
  Stream<List<Photo>> streamEventPhotos(String eventId) {
    return _firebase.photosCollection
        .where('eventId', isEqualTo: eventId)
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Photo.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // Delete photo
  Future<bool> deletePhoto(String photoId) async {
    try {
      final user = _firebase.currentUser;
      if (user == null) return false;

      // Get photo data first
      final photoDoc = await _firebase.photosCollection.doc(photoId).get();
      if (!photoDoc.exists) return false;

      final photo = Photo.fromMap(photoDoc.data() as Map<String, dynamic>);

      // Check if user owns the photo
      if (photo.uploaderId != user.uid) return false;

      // Delete from Storage
      final storageRef = _firebase.getPhotoStorageRef(photo.eventId, photoId);
      await storageRef.delete();

      // Delete from Firestore
      await _firebase.photosCollection.doc(photoId).delete();

      // Update event photo count
      await _firebase.eventsCollection.doc(photo.eventId).update({
        'photoCount': FieldValue.increment(-1),
      });

      Logger.info('Photo deleted successfully: $photoId');
      return true;
    } catch (e) {
      Logger.error('Failed to delete photo: $e');
      return false;
    }
  }
}
