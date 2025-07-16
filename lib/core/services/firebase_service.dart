import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../utils/logger.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Getters
  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
  FirebaseStorage get storage => _storage;

  // Anonymous Authentication
  Future<User?> signInAnonymously() async {
    try {
      final UserCredential result = await _auth.signInAnonymously();
      Logger.info('Anonymous sign in successful: ${result.user?.uid}');
      return result.user;
    } catch (e) {
      Logger.error('Anonymous sign in failed: $e');
      return null;
    }
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Check if user is signed in
  bool get isSignedIn => _auth.currentUser != null;

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Logger.info('User signed out successfully');
    } catch (e) {
      Logger.error('Sign out failed: $e');
    }
  }

  // Collections
  CollectionReference get eventsCollection => _firestore.collection('events');
  CollectionReference get photosCollection => _firestore.collection('photos');
  CollectionReference get participantsCollection =>
      _firestore.collection('participants');

  // Storage references
  Reference getEventStorageRef(String eventId) =>
      _storage.ref().child('events/$eventId');
  Reference getPhotoStorageRef(String eventId, String photoId) =>
      _storage.ref().child('events/$eventId/photos/$photoId');
}
