import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:succucare_app/features/notifications/data/models/models.dart';
import 'package:succucare_app/features/notifications/ui/providers/providers.dart';
import 'package:succucare_app/features/notifications/ui/views/alerts_view.dart';

class _SeededAlertsNotifier extends AlertsNotifier {
  _SeededAlertsNotifier(this.seed);

  final NotificationsState seed;

  @override
  Future<NotificationsState> build() async => seed;
}

AppNotification _notification(String id, {String? moistureLevel}) {
  return AppNotification(
    messageId: id,
    title: 'Título $id',
    body: 'Cuerpo $id',
    sentDate: DateTime(2026, 10, 12, 12),
    data: moistureLevel == null ? null : {'moistureLevel': moistureLevel},
  );
}

NotificationsState _state({
  List<AppNotification>? notifications,
  Set<String> readMessageIds = const {},
}) {
  return NotificationsState(
    status: NotificationsStatus.authorized,
    notifications: notifications ?? [_notification('a'), _notification('b')],
    readMessageIds: readMessageIds,
  );
}

({Widget widget, ProviderContainer container}) _subject(
  NotificationsState seed,
) {
  final container = ProviderContainer(
    overrides: [alertsProvider.overrideWith(() => _SeededAlertsNotifier(seed))],
  );
  addTearDown(container.dispose);

  return (
    widget: UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: AlertsView()),
    ),
    container: container,
  );
}

/// Pumps the view and settles the async notifier's initial build without
/// tripping over the loading spinner's infinite animation.
Future<void> _pumpAlerts(WidgetTester tester, Widget widget) async {
  await tester.pumpWidget(widget);
  await tester.pump();
  await tester.pump();
}

NotificationsState _stateOf(ProviderContainer container) =>
    container.read(alertsProvider).requireValue;

void main() {
  testWidgets('renders the header, filters and notification cards', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final subject = _subject(
      _state(
        notifications: [
          _notification('a', moistureLevel: 'Low'),
          _notification('b', moistureLevel: 'High'),
        ],
      ),
    );

    await _pumpAlerts(tester, subject.widget);

    expect(find.text('Alertas y Cuidados'), findsOneWidget);
    expect(find.text('Monitoreo biométrico y alertas de riego'), findsOneWidget);
    expect(find.text('2 nuevas'), findsOneWidget);
    expect(find.text('Marcar todas'), findsOneWidget);

    expect(find.text('Todas'), findsOneWidget);
    expect(find.text('Sin leer'), findsOneWidget);
    expect(find.text('(2)'), findsNWidgets(2));

    expect(find.text('Título a'), findsOneWidget);
    expect(find.text('Cuerpo a'), findsOneWidget);
    expect(find.text('Título b'), findsOneWidget);
    expect(find.text('Cuerpo b'), findsOneWidget);
    expect(find.text('Registrar Riego'), findsNWidgets(2));
    expect(find.text('Nivel bajo'), findsOneWidget);
    expect(find.text('Nivel alto'), findsOneWidget);

    expect(find.byTooltip('Marcar como leída'), findsNWidgets(2));
    expect(find.byTooltip('Descartar'), findsNWidgets(2));

    expect(find.text('Sensores sincronizados'), findsOneWidget);
    expect(find.text('Limpiar leídas'), findsOneWidget);
  });

  testWidgets('shows the empty state when there are no notifications', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final subject = _subject(_state(notifications: const []));

    await _pumpAlerts(tester, subject.widget);

    expect(find.text('¡Todo en orden!'), findsOneWidget);
    expect(find.text('Al día'), findsOneWidget);
    expect(find.text('Registrar Riego'), findsNothing);
    expect(find.text('Título a'), findsNothing);
    expect(find.text('Limpiar leídas'), findsOneWidget);
  });

  testWidgets('filters between all and unread notifications', (tester) async {
    tester.view.physicalSize = const Size(900, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final subject = _subject(_state(readMessageIds: {'a'}));

    await _pumpAlerts(tester, subject.widget);

    expect(find.text('Título a'), findsOneWidget);
    expect(find.text('Título b'), findsOneWidget);
    expect(find.text('1 nuevas'), findsOneWidget);

    await tester.tap(find.text('Sin leer'));
    await tester.pump();

    expect(find.text('Título a'), findsNothing);
    expect(find.text('Título b'), findsOneWidget);

    await tester.tap(find.text('Todas'));
    await tester.pump();

    expect(find.text('Título a'), findsOneWidget);
    expect(find.text('Título b'), findsOneWidget);
  });

  testWidgets('marks a single notification as read', (tester) async {
    tester.view.physicalSize = const Size(900, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final subject = _subject(_state());

    await _pumpAlerts(tester, subject.widget);

    await tester.tap(find.byTooltip('Marcar como leída').first);
    await tester.pump();

    expect(_stateOf(subject.container).readMessageIds, contains('a'));
    expect(find.text('1 nuevas'), findsOneWidget);
  });

  testWidgets('registering watering marks the notification as read', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final subject = _subject(_state());

    await _pumpAlerts(tester, subject.widget);

    await tester.tap(find.text('Registrar Riego').first);
    await tester.pump();

    expect(_stateOf(subject.container).readMessageIds, contains('a'));
  });

  testWidgets('dismissing removes the notification', (tester) async {
    tester.view.physicalSize = const Size(900, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final subject = _subject(_state());

    await _pumpAlerts(tester, subject.widget);

    await tester.tap(find.byTooltip('Descartar').first);
    await tester.pump();

    expect(find.text('Título a'), findsNothing);
    expect(find.text('Título b'), findsOneWidget);
    expect(_stateOf(subject.container).notifications.map((n) => n.messageId), [
      'b',
    ]);
  });

  testWidgets('mark all as read clears every unread indicator', (tester) async {
    tester.view.physicalSize = const Size(900, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final subject = _subject(_state());

    await _pumpAlerts(tester, subject.widget);

    await tester.tap(find.text('Marcar todas'));
    await tester.pump();

    expect(_stateOf(subject.container).unreadCount, 0);
    expect(find.text('Al día'), findsOneWidget);
  });

  testWidgets('clearing read removes already-read notifications', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final subject = _subject(_state(readMessageIds: {'a'}));

    await _pumpAlerts(tester, subject.widget);

    await tester.tap(find.text('Limpiar leídas'));
    await tester.pump();

    expect(find.text('Título a'), findsNothing);
    expect(find.text('Título b'), findsOneWidget);
    expect(_stateOf(subject.container).notifications.map((n) => n.messageId), [
      'b',
    ]);
  });
}
