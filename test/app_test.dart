import 'package:flutter_test/flutter_test.dart';

import 'package:local_voice_call/app/app.dart';

void main() {
  testWidgets('home screen shows the Proxima branding and entry points',
      (tester) async {
    await tester.pumpWidget(const ProximaApp());
    await tester.pump();

    expect(find.text('Proxima'), findsOneWidget);
    expect(find.text('Start Call'), findsOneWidget);
    expect(find.text('Join Call'), findsOneWidget);
  });

  testWidgets('tapping Start Call opens the name / mode sheet', (tester) async {
    await tester.pumpWidget(const ProximaApp());
    await tester.pump();

    await tester.tap(find.text('Start Call'));
    await tester.pumpAndSettle();

    // The bottom sheet collects a display name and a media mode before hosting.
    expect(find.text('Your name'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Voice'), findsOneWidget);
    expect(find.text('Video'), findsOneWidget);
  });
}
