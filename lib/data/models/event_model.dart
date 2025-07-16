class Event {
  final String id;
  final String name;
  final String? description;
  final String hostId;
  final String joinCode;
  final String? qrCode;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final bool isActive;
  final int photoCount;
  final List<String> participantIds;

  Event({
    required this.id,
    required this.name,
    this.description,
    required this.hostId,
    required this.joinCode,
    this.qrCode,
    required this.createdAt,
    this.expiresAt,
    this.isActive = true,
    this.photoCount = 0,
    this.participantIds = const [],
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      hostId: map['hostId'] ?? '',
      joinCode: map['joinCode'] ?? '',
      qrCode: map['qrCode'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      expiresAt: map['expiresAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['expiresAt'])
          : null,
      isActive: map['isActive'] ?? true,
      photoCount: map['photoCount'] ?? 0,
      participantIds: List<String>.from(map['participantIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'hostId': hostId,
      'joinCode': joinCode,
      'qrCode': qrCode,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'expiresAt': expiresAt?.millisecondsSinceEpoch,
      'isActive': isActive,
      'photoCount': photoCount,
      'participantIds': participantIds,
    };
  }
}
