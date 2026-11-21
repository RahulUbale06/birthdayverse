
import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:file_saver/file_saver.dart';

import '../models/birthday_config.dart';

class BirthdayPackageExporter {
  static Future<void> exportBirthdayPackage(
    BirthdayConfig birthday,
  ) async {
    // Validate selected photos.
    if (birthday.photoBytes.length != birthday.photos.length) {
      throw Exception(
        'Photo data is incomplete. Please select your photos again.',
      );
    }

    final archive = Archive();

    final packagedPhotoPaths = <String>[];

    // Add photos to the ZIP archive.
    for (int i = 0; i < birthday.photoBytes.length; i++) {
      final originalPath = birthday.photos[i];
      final extension = _getExtension(originalPath, 'jpg');

      final fileName =
          'photo_${(i + 1).toString().padLeft(2, '0')}.$extension';

      final assetPath = 'assets/recipient/images/$fileName';

      packagedPhotoPaths.add(assetPath);

      archive.addFile(
        ArchiveFile.bytes(
          assetPath,
          birthday.photoBytes[i],
        ),
      );
    }

    // Add music to the ZIP archive.
    String? packagedMusicPath;

    if (birthday.musicBytes != null) {
      final originalName =
          birthday.musicName ?? birthday.musicPath ?? 'birthday_song.mp3';

      final extension = _getExtension(originalName, 'mp3');

      final musicFileName = 'birthday_song.$extension';

      packagedMusicPath =
          'assets/recipient/music/$musicFileName';

      archive.addFile(
        ArchiveFile.bytes(
          packagedMusicPath,
          birthday.musicBytes!,
        ),
      );
    }

    // Generate lightweight recipient configuration.
    final config = birthday.toPackageJson(
      packagedPhotoPaths: packagedPhotoPaths,
      packagedMusicPath: packagedMusicPath,
    );

    final configJson = const JsonEncoder.withIndent('  ')
        .convert(config);

    archive.addFile(
      ArchiveFile.string(
        'birthday_config.json',
        configJson,
      ),
    );

    // Generate ZIP bytes.
    final zipBytes = Uint8List.fromList(
      ZipEncoder().encode(archive),
    );

    // Generate a safe filename.
    final safeName = _safeFileName(birthday.recipientName);

    // Save ZIP file.
    await FileSaver.instance.saveFile(
      name: 'birthdayverse_$safeName',
      bytes: zipBytes,
      fileExtension: 'zip',
      mimeType: MimeType.zip,
    );
  }

  static String _getExtension(String fileName, String fallback) {
    final cleanName = fileName.split(RegExp(r'[/\\]')).last;

    final dotIndex = cleanName.lastIndexOf('.');

    if (dotIndex == -1 || dotIndex == cleanName.length - 1) {
      return fallback;
    }

    return cleanName.substring(dotIndex + 1).toLowerCase();
  }

  static String _safeFileName(String value) {
    final cleaned = value
        .trim()
        .replaceAll(RegExp(r'[^a-zA-Z0-9_-]+'), '_')
        .replaceAll(RegExp(r'_+'), '_');

    return cleaned.isEmpty ? 'birthday' : cleaned;
  }
}
