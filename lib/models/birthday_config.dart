
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

  final List<String> photos;
  final List<Uint8List> photoBytes;

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

  // Complete creator configuration serialization.
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

  // Recipient package serialization.
  Map<String, dynamic> toPackageJson({
    required List<String> packagedPhotoPaths,
    String? packagedMusicPath,
  }) {
    return {
      'id': id,
      'recipientName': recipientName,
      'nickname': nickname,
      'relationship': relationship,
      'birthdayDate': birthdayDate.toIso8601String(),
      'birthdayMessage': birthdayMessage,
      'themeId': themeId,
      'birthdayLetter': birthdayLetter,
      'photos': packagedPhotoPaths,
      'musicPath': packagedMusicPath,
      'musicName': musicName,
    };
  }

  // Restore the complete creator configuration.
  factory BirthdayConfig.fromJson(Map<String, dynamic> json) {
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
      birthdayMessage: json['birthdayMessage'] as String,
      themeId: json['themeId'] as String,
      birthdayLetter: json['birthdayLetter'] as String,
      photos: List<String>.from(json['photos'] ?? []),
      photoBytes: encodedPhotos
          .map((photo) => base64Decode(photo as String))
          .toList(),
      musicPath: json['musicPath'] as String?,
      musicName: json['musicName'] as String?,
      musicBytes: encodedMusic == null
          ? null
          : base64Decode(encodedMusic),
    );
  }

  // Restore a recipient configuration from packaged JSON.
  // Media is loaded separately from Flutter assets.
  factory BirthdayConfig.fromPackageJson(
    Map<String, dynamic> json,
  ) {
    return BirthdayConfig(
      id: json['id'] as String,
      recipientName: json['recipientName'] as String,
      nickname: json['nickname'] as String? ?? '',
      relationship: json['relationship'] as String? ?? '',
      birthdayDate: DateTime.parse(
        json['birthdayDate'] as String,
      ),
      birthdayMessage: json['birthdayMessage'] as String,
      themeId: json['themeId'] as String,
      birthdayLetter: json['birthdayLetter'] as String,
      photos: List<String>.from(json['photos'] ?? []),
      photoBytes: const [],
      musicPath: json['musicPath'] as String?,
      musicName: json['musicName'] as String?,
      musicBytes: null,
    );
  }
}
