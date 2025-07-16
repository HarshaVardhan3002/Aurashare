import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/event_model.dart';
import '../../data/models/participant_model.dart';
import 'firebase_service.dart';
import '../utils/logger.dart';

class EventService {
  static final EventService _instance = EventService._internal();
  factory EventService() => _instance;
  EventService._internal();

  final FirebaseService _firebase = FirebaseService();
  final Uuid _uuid = const Uuid();

  // Generate random 6-digit PIN
  String _generateJoinCode() {
    return (100000 +
            (999999 - 100000) *
                (DateTime.now().millisecondsSinceEpoch % 1000) /
                1000)
        .floor()
        .toString();
  }

  // Create new event
  Future<Event?> createEvent({
    required String name,
    String? description,
    DateTime? expiresAt,
  }) async {
    try {
      final user = _firebase.currentUser;
      if (user == null) {
        Logger.error('User not authenticated');
        return null;
      }

      final eventId = _uuid.v4();
      final joinCode = _generateJoinCode();

      final event = Event(
        id: eventId,
        name: name,
        description: description,
        hostId: user.uid,
        joinCode: joinCode,
        createdAt: DateTime.now(),
        expiresAt: expiresAt,
      );

      await _firebase.eventsCollection.doc(eventId).set(event.toMap());
      Logger.info('Event created successfully: $eventId');
      return event;
    } catch (e) {
      Logger.error('Failed to create event: $e');
      return null;
    }
  }

  // Join event by PIN
  Future<Event?> joinEventByPin(String joinCode, {String? nickname}) async {
    try {
      final user = _firebase.currentUser;
      if (user == null) {
        Logger.error('User not authenticated');
        return null;
      }

      // Find event by join code
      final querySnapshot = await _firebase.eventsCollection
          .where('joinCode', isEqualTo: joinCode)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        Logger.error('Event not found with join code: $joinCode');
        return null;
      }

      final eventDoc = querySnapshot.docs.first;
      final event = Event.fromMap(eventDoc.data() as Map<String, dynamic>);

      // Check if event is expired
      if (event.expiresAt != null &&
          event.expiresAt!.isBefore(DateTime.now())) {
        Logger.error('Event has expired');
        return null;
      }

      // Add participant
      await _addParticipant(event.id, user.uid, nickname);

      Logger.info('Successfully joined event: ${event.id}');
      return event;
    } catch (e) {
      Logger.error('Failed to join event: $e');
      return null;
    }
  }

  // Add participant to event
  Future<void> _addParticipant(
      String eventId, String userId, String? nickname) async {
    try {
      final participant = Participant(
        id: userId,
        eventId: eventId,
        nickname: nickname,
        joinedAt: DateTime.now(),
      );

      await _firebase.participantsCollection
          .doc('${eventId}_$userId')
          .set(participant.toMap());

      // Update event participant count
      await _firebase.eventsCollection.doc(eventId).update({
        'participantIds': FieldValue.arrayUnion([userId]),
      });

      Logger.info('Participant added to event: $eventId');
    } catch (e) {
      Logger.error('Failed to add participant: $e');
    }
  }

  // Get event by ID
  Future<Event?> getEvent(String eventId) async {
    try {
      final doc = await _firebase.eventsCollection.doc(eventId).get();
      if (doc.exists) {
        return Event.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      Logger.error('Failed to get event: $e');
      return null;
    }
  }

  // Get user's events
  Stream<List<Event>> getUserEvents() {
    final user = _firebase.currentUser;
    if (user == null) return Stream.value([]);

    return _firebase.eventsCollection
        .where('participantIds', arrayContains: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
}
