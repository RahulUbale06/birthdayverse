
import 'package:flutter_test/flutter_test.dart';
import 'package:birthdayverse/main.dart';

void main() {
  testWidgets('BirthdayVerse app launches',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const BirthdayVerseApp(),
    );

    expect(find.text('BirthdayVerse'), findsOneWidget);
  });
}
