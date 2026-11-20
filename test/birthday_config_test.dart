
import 'package:flutter_test/flutter_test.dart';
import 'package:birthdayverse/models/birthday_config.dart';

void main() {
  test('BirthdayConfig JSON serialization works', () {
    final birthday = BirthdayConfig(
      id: 'birthday_001',
      recipientName: 'Priya',
      nickname: 'Princess',
      relationship: 'Best Friend',
      birthdayDate: DateTime(2026, 12, 25),
      birthdayMessage: 'Happy Birthday!',
      themeId: 'pink_dream',
      birthdayLetter: 'You are amazing!',
      photos: ['photo1.jpg', 'photo2.jpg'],
      musicPath: 'music/birthday.mp3',
      musicName: 'Birthday Song',
    );

    final json = birthday.toJson();

    final restored = BirthdayConfig.fromJson(json);

    expect(restored.id, 'birthday_001');
    expect(restored.recipientName, 'Priya');
    expect(restored.nickname, 'Princess');
    expect(restored.relationship, 'Best Friend');
    expect(restored.birthdayDate, birthday.birthdayDate);
    expect(restored.birthdayMessage, 'Happy Birthday!');
    expect(restored.themeId, 'pink_dream');
    expect(restored.birthdayLetter, 'You are amazing!');
    expect(restored.photos.length, 2);
    expect(restored.musicPath, 'music/birthday.mp3');
    expect(restored.musicName, 'Birthday Song');
  });
}
