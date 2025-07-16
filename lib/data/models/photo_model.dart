class Photo {
  final String id;
  final String eventId;
  final String uploaderId;
  final String? uploaderNickname;
  final String fileName;
  final String storageUrl;
  final String? thumbnailUrl;
  final DateTime uploadedAt;
  final int fileSize;
  final bool isUploaded;
  final String? localPath;

  Photo({
    required this.id,
    required this.eventId,
    required this.uploaderId,
    this.uploaderNickname,
    required this.fileName,
    required this.storageUrl,
    this.thumbnailUrl,
    required this.uploadedAt,
    this.fileSize = 0,
    this.isUploaded = false,
    this.localPath,
  });

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      id: map['id'] ?? '',
      eventId: map['eventId'] ?? '',
      uploaderId: map['uploaderId'] ?? '',
      uploaderNickname: map['uploaderNickname'],
      fileName: map['fileName'] ?? '',
      storageUrl: map['storageUrl'] ?? '',
      thumbnailUrl: map['thumbnailUrl'],
      uploadedAt: DateTime.fromMillisecondsSinceEpoch(map['uploadedAt'] ?? 0),
      fileSize: map['fileSize'] ?? 0,
      isUploaded: map['isUploaded'] ?? false,
      localPath: map['localPath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventId': eventId,
      'uploaderId': uploaderId,
      'uploaderNickname': uploaderNickname,
      'fileName': fileName,
      'storageUrl': storageUrl,
      'thumbnailUrl': thumbnailUrl,
      'uploadedAt': uploadedAt.millisecondsSinceEpoch,
      'fileSize': fileSize,
      'isUploaded': isUploaded,
      'localPath': localPath,
    };
  }

  Photo copyWith({
    String? id,
    String? eventId,
    String? uploaderId,
    String? uploaderNickname,
    String? fileName,
    String? storageUrl,
    String? thumbnailUrl,
    DateTime? uploadedAt,
    int? fileSize,
    bool? isUploaded,
    String? localPath,
  }) {
    return Photo(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      uploaderId: uploaderId ?? this.uploaderId,
      uploaderNickname: uploaderNickname ?? this.uploaderNickname,
      fileName: fileName ?? this.fileName,
      storageUrl: storageUrl ?? this.storageUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      fileSize: fileSize ?? this.fileSize,
      isUploaded: isUploaded ?? this.isUploaded,
      localPath: localPath ?? this.localPath,
    );
  }
}
