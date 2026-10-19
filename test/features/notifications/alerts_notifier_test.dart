import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:succucare_app/core/utils/utils.dart';
import 'package:succucare_app/features/notifications/data/models/models.dart';
import 'package:succucare_app/features/notifications/data/repositories/repositories.dart';
import 'package:succucare_app/features/notifications/ui/providers/providers.dart';
import 'package:succucare_app/features/notifications/ui/views/alerts_view.dart';

class _FakeNotificationsRepository implements NotificationsRepository {
  _FakeNotificationsRepository({this.status = NotificationsStatus.authorized});

  final NotificationsStatus status;

  @override
  Future<Result<NotificationsStatus>> initNotifications() async =>
      Success(status);

  @override
  Stream<Result<AppNotification>> onBackground() => const Stream.empty();

  @override
  Stream<Result<AppNotification>> onForeground() => const Stream.empty();

  @override
  Future<Result<String>> getToken() async => Success('faketoken0ujik');

  @override
  Future<void> saveToken(String token) => Completer().future;
}

/// A repository whose initialization never completes, keeping the notifier in
/// the loading state so action methods are forced to no-op.
class _PendingNotificationsRepository implements NotificationsRepository {
  @override
  Future<Result<NotificationsStatus>> initNotifications() =>
      Completer<Result<NotificationsStatus>>().future;

  @override
  Stream<Result<AppNotification>> onBackground() => const Stream.empty();

  @override
  Stream<Result<AppNotification>> onForeground() => const Stream.empty();

  @override
  Future<Result<String>> getToken() => Completer<Result<String>>().future;

  @override
  Future<void> saveToken(String token) => Completer().future;
}

/// An [AlertsNotifier] whose initial inbox is supplied directly, so the action
/// methods can be exercised without wiring up FCM streams.
class _SeededAlertsNotifier extends AlertsNotifier {
  _SeededAlertsNotifier(this.seed);

  final NotificationsState seed;

  @override
  Future<NotificationsState> build() async => seed;
}

AppNotification _notification(
  String id, {
  String? moistureLevel,
  String? imageUrl,
  DateTime? sentDate,
}) {
  return AppNotification(
    messageId: id,
    title: 'Título $id',
    body: 'Cuerpo $id',
    sentDate: sentDate ?? DateTime(2026, 10, 12, 12),
    data: moistureLevel == null ? null : {'moistureLevel': moistureLevel},
    imageUrl: imageUrl,
  );
}

NotificationsState _seededState({
  List<AppNotification>? notifications,
  Set<String> readMessageIds = const {},
  AlertsFilter filter = AlertsFilter.all,
}) {
  return NotificationsState(
    status: NotificationsStatus.authorized,
    token: 'faketoken0ujik',
    notifications: notifications ?? [_notification('a'), _notification('b')],
    filter: filter,
    readMessageIds: readMessageIds,
  );
}

Future<({ProviderContainer container, AlertsNotifier notifier})> _containerWith(
  NotificationsState seed,
) async {
  final container = ProviderContainer(
    overrides: [alertsProvider.overrideWith(() => _SeededAlertsNotifier(seed))],
  );
  addTearDown(container.dispose);

  // Keep the auto-dispose provider alive for the duration of the test.
  final subscription = container.listen(alertsProvider, (_, _) {});
  addTearDown(subscription.close);

  await container.read(alertsProvider.future);
  final notifier = container.read(alertsProvider.notifier);
  return (container: container, notifier: notifier);
}

NotificationsState _stateOf(ProviderContainer container) =>
    container.read(alertsProvider).requireValue;

void main() {
  group('AlertsNotifier.build', () {
    test('adopts the repository notification status', () async {
      final container = ProviderContainer(
        overrides: [
          notificationsRepositoryProvider.overrideWithValue(
            _FakeNotificationsRepository(
              status: NotificationsStatus.unauthorized,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = await container.read(alertsProvider.future);

      expect(state.status, NotificationsStatus.unauthorized);
      expect(state.notifications, isEmpty);
      expect(state.filter, AlertsFilter.all);
      expect(state.readMessageIds, isEmpty);
    });
  });

  group('AlertsNotifier actions', () {
    test(
      'markAsRead marks a single notification without touching the others',
      () async {
        final subject = await _containerWith(_seededState());

        subject.notifier.markAsRead('a');

        final state = _stateOf(subject.container);
        expect(state.readMessageIds, {'a'});
        expect(state.isUnread('a'), isFalse);
        expect(state.isUnread('b'), isTrue);
        expect(state.unreadCount, 1);
      },
    );

    test('registerWatering marks the notification as read', () async {
      final subject = await _containerWith(_seededState());

      subject.notifier.registerWatering('b');

      final state = _stateOf(subject.container);
      expect(state.isUnread('b'), isFalse);
      expect(state.readMessageIds, contains('b'));
    });

    test('markAllAsRead marks every notification in the inbox', () async {
      final subject = await _containerWith(_seededState());

      subject.notifier.markAllAsRead();

      final state = _stateOf(subject.container);
      expect(state.readMessageIds, {'a', 'b'});
      expect(state.unreadCount, 0);
    });

    test('dismiss removes the notification and its read marker', () async {
      final subject = await _containerWith(_seededState(readMessageIds: {'a'}));

      subject.notifier.dismiss('a');

      final state = _stateOf(subject.container);
      expect(state.notifications.map((n) => n.messageId), ['b']);
      expect(state.readMessageIds, isEmpty);
    });

    test(
      'clearRead removes read notifications and keeps unread ones',
      () async {
        final subject = await _containerWith(
          _seededState(readMessageIds: {'a'}),
        );

        subject.notifier.clearRead();

        final state = _stateOf(subject.container);
        expect(state.notifications.map((n) => n.messageId), ['b']);
        expect(state.readMessageIds, isEmpty);
        expect(state.unreadCount, 1);
      },
    );

    test('setFilter narrows visibleNotifications to unread items', () async {
      final subject = await _containerWith(_seededState(readMessageIds: {'a'}));

      subject.notifier.setFilter(AlertsFilter.unread);

      final state = _stateOf(subject.container);
      expect(state.filter, AlertsFilter.unread);
      expect(state.visibleNotifications.map((n) => n.messageId), ['b']);

      subject.notifier.setFilter(AlertsFilter.all);
      expect(
        _stateOf(
          subject.container,
        ).visibleNotifications.map((n) => n.messageId),
        ['a', 'b'],
      );
    });

    test('actions are ignored while the state is not yet available', () async {
      final container = ProviderContainer(
        overrides: [
          notificationsRepositoryProvider.overrideWithValue(
            _PendingNotificationsRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(alertsProvider, (_, _) {});
      addTearDown(subscription.close);

      final notifier = container.read(alertsProvider.notifier);
      notifier.markAsRead('a');
      notifier.markAllAsRead();
      notifier.setFilter(AlertsFilter.unread);
      notifier.dismiss('a');
      notifier.clearRead();

      expect(container.read(alertsProvider).hasValue, isFalse);
    });
  });

  group('formatRelativeTime', () {
    final now = DateTime(2026, 10, 12, 12, 0);

    test('formats minutes, hours and days in Spanish', () {
      expect(
        formatRelativeTime(now.subtract(const Duration(seconds: 30)), now: now),
        'Hace un momento',
      );
      expect(
        formatRelativeTime(now.subtract(const Duration(minutes: 25)), now: now),
        'Hace 25 min',
      );
      expect(
        formatRelativeTime(now.subtract(const Duration(hours: 2)), now: now),
        'Hace 2h',
      );
      expect(
        formatRelativeTime(now.subtract(const Duration(days: 3)), now: now),
        'Hace 3d',
      );
    });

    test('formats weeks and months for older notifications', () {
      expect(
        formatRelativeTime(now.subtract(const Duration(days: 14)), now: now),
        'Hace 2 sem',
      );
      expect(
        formatRelativeTime(now.subtract(const Duration(days: 60)), now: now),
        'Hace 2 mes',
      );
    });

    test('treats a future date as just now', () {
      expect(
        formatRelativeTime(now.add(const Duration(minutes: 5)), now: now),
        'Hace un momento',
      );
    });
  });
}
