
import 'dart:convert';
import 'dart:typed_data';

class BirthdayConfig {
  final String id;
  final String recipientName;
  final String nickname;
  final String relationship;
  final DateTime birthdayDate;
  final String birthdayMessage;
  final String themeId;
  final String birthdayLetter;

  // Photo information
  final List<String> photos;
  final List<Uint8List> photoBytes;

  // Music information
  final String? musicPath;
  final String? musicName;
  final Uint8List? musicBytes;

  const BirthdayConfig({
    required this.id,
    required this.recipientName,
    this.nickname = '',
    this.relationship = '',
    required this.birthdayDate,
    required this.birthdayMessage,
    required this.themeId,
    required this.birthdayLetter,
    this.photos = const [],
    this.photoBytes = const [],
    this.musicPath,
    this.musicName,
    this.musicBytes,
  });

  // Convert configuration into JSON.
  // Binary media is encoded using Base64.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipientName': recipientName,
      'nickname': nickname,
      'relationship': relationship,
      'birthdayDate': birthdayDate.toIso8601String(),
      'birthdayMessage': birthdayMessage,
      'themeId': themeId,
      'birthdayLetter': birthdayLetter,
      'photos': photos,

      'photoBytes': photoBytes
          .map((bytes) => base64Encode(bytes))
          .toList(),

      'musicPath': musicPath,
      'musicName': musicName,

      'musicBytes': musicBytes == null
          ? null
          : base64Encode(musicBytes!),
    };
  }

  // Restore configuration from JSON.
  factory BirthdayConfig.fromJson(
    Map<String, dynamic> json,
  ) {
    final encodedPhotos =
        json['photoBytes'] as List<dynamic>? ?? [];

    final encodedMusic = json['musicBytes'] as String?;

    return BirthdayConfig(
      id: json['id'] as String,
      recipientName: json['recipientName'] as String,
      nickname: json['nickname'] as String? ?? '',
      relationship: json['relationship'] as String? ?? '',

      birthdayDate: DateTime.parse(
        json['birthdayDate'] as String,
      ),

      birthdayMessage:
          json['birthdayMessage'] as String,

      themeId: json['themeId'] as String,

      birthdayLetter:
          json['birthdayLetter'] as String,

      photos: List<String>.from(
        json['photos'] ?? [],
      ),

      photoBytes: encodedPhotos
          .map(
            (photo) => base64Decode(photo as String),
          )
          .toList(),

      musicPath: json['musicPath'] as String?,
      musicName: json['musicName'] as String?,

      musicBytes: encodedMusic == null
          ? null
          : base64Decode(encodedMusic),
    );
  }
}
