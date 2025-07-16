class Participant {
  final String id;
  final String eventId;
  final String? nickname;
  final DateTime joinedAt;
  final int uploadedPhotos;
  final bool isAnonymous;

  Participant({
    required this.id,
    required this.eventId,
    this.nickname,
    required this.joinedAt,
    this.uploadedPhotos = 0,
    this.isAnonymous = true,
  });

  factory Participant.fromMap(Map<String, dynamic> map) {
    return Participant(
      id: map['id'] ?? '',
      eventId: map['eventId'] ?? '',
      nickname: map['nickname'],
      joinedAt: DateTime.fromMillisecondsSinceEpoch(map['joinedAt'] ?? 0),
      uploadedPhotos: map['uploadedPhotos'] ?? 0,
      isAnonymous: map['isAnonymous'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventId': eventId,
      'nickname': nickname,
      'joinedAt': joinedAt.millisecondsSinceEpoch,
      'uploadedPhotos': uploadedPhotos,
      'isAnonymous': isAnonymous,
    };
  }
}
