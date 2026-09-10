import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:succucare_app/features/garden/views/views.dart';

void main() {
  testWidgets('renders the garden home screen with mock plants', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: MyGardenHomeView()),
      ),
    );
    await tester.pump();

    expect(find.text('Succulent AI'), findsOneWidget);
    expect(find.text('My Garden'), findsOneWidget);
    expect(find.text('4 Plants'), findsOneWidget);

    expect(find.text('Luna'), findsOneWidget);
    expect(find.text('Echeveria Elegans'), findsOneWidget);
    expect(find.text('Jade'), findsOneWidget);
    expect(find.text('Zebra'), findsOneWidget);
    expect(find.text('Pearls'), findsOneWidget);

    expect(find.text('Needs Water'), findsOneWidget);
    expect(find.text('Needs Light'), findsOneWidget);

    expect(find.text('Garden'), findsOneWidget);
    expect(find.text('Scan'), findsOneWidget);
    expect(find.text('Care'), findsOneWidget);
    expect(find.text('Alerts'), findsOneWidget);
  });

  testWidgets('filters plants by category', (tester) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: MyGardenHomeView()),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Suculentas'));
    await tester.pumpAndSettle();

    expect(find.text('3 Plants'), findsOneWidget);
    expect(find.text('Luna'), findsOneWidget);
    expect(find.text('Jade'), findsOneWidget);
    expect(find.text('Pearls'), findsNothing);
  });

  testWidgets('searches plants by name', (tester) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: MyGardenHomeView()),
      ),
    );
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'zebra');
    await tester.pumpAndSettle();

    expect(find.text('1 Plant'), findsOneWidget);
    expect(find.text('Zebra'), findsOneWidget);
    expect(find.text('Luna'), findsNothing);
  });
}