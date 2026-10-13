import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:succucare_app/core/theme/icon_size.dart';

import 'package:succucare_app/core/theme/insets.dart';
import 'package:succucare_app/features/notifications/data/models/models.dart';
import 'package:succucare_app/features/notifications/ui/providers/providers.dart';

/// Formats [sentDate] relative to [now] using the Spanish wording from the
/// Stitch "Alertas y Cuidados" design (for example "Hace 25 min" or "Hace 2h").
String formatRelativeTime(DateTime sentDate, {DateTime? now}) {
  final reference = now ?? DateTime.now();
  final difference = reference.difference(sentDate);

  if (difference.inSeconds < 60) return 'Hace un momento';
  if (difference.inMinutes < 60) return 'Hace ${difference.inMinutes} min';
  if (difference.inHours < 24) return 'Hace ${difference.inHours}h';
  if (difference.inDays < 7) return 'Hace ${difference.inDays}d';
  if (difference.inDays < 30) return 'Hace ${difference.inDays ~/ 7} sem';
  if (difference.inDays < 365) return 'Hace ${difference.inDays ~/ 30} mes';
  return 'Hace ${difference.inDays ~/ 365} a';
}

class AlertsView extends ConsumerWidget {
  const AlertsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(alertsProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: alerts.when(
          data: (state) => _AlertsContent(state: state),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => const _AlertsErrorState(),
        ),
      ),
    );
  }
}

class _AlertsContent extends ConsumerWidget {
  const _AlertsContent({required this.state});

  final NotificationsState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(alertsProvider.notifier);
    final visibleNotifications = state.visibleNotifications;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Insets.medium,
        Insets.medium,
        Insets.medium,
        Insets.large,
      ),
      children: [
        _AlertsHeader(state: state, onMarkAllAsRead: notifier.markAllAsRead),
        const SizedBox(height: Insets.medium),
        _FilterChips(state: state, onFilterSelected: notifier.setFilter),
        const SizedBox(height: Insets.medium),
        if (visibleNotifications.isEmpty)
          const _EmptyState()
        else
          for (final notification in visibleNotifications)
            Padding(
              padding: const EdgeInsets.only(
                bottom: Insets.small + Insets.xsmall,
              ),
              child: _NotificationCard(
                notification: notification,
                isUnread: state.isUnread(notification.messageId),
                onRegisterWatering: () =>
                    notifier.registerWatering(notification.messageId),
                onMarkAsRead: () => notifier.markAsRead(notification.messageId),
                onDismiss: () => notifier.dismiss(notification.messageId),
              ),
            ),
        const SizedBox(height: Insets.small),
        _CleanupBar(
          hasReadNotifications: state.notifications.length > state.unreadCount,
          onClearRead: notifier.clearRead,
        ),
      ],
    );
  }
}

class _AlertsHeader extends StatelessWidget {
  const _AlertsHeader({required this.state, required this.onMarkAllAsRead});

  final NotificationsState state;
  final VoidCallback onMarkAllAsRead;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hasUnread = state.unreadCount > 0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Alertas y Cuidados',
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            _UnreadBadge(count: state.unreadCount),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Monitoreo y alertas de riego',
              style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
            ),
            IconButton(
              icon: const Icon(Symbols.done_all, size: IconSize.small),
              constraints: BoxConstraints(),
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              style: const ButtonStyle(
                tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap, // the '2023' part
              ),
              onPressed: hasUnread ? onMarkAllAsRead : null,
            ),
          ],
        ),
      ],
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hasUnread = count > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: hasUnread
            ? colorScheme.tertiary
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        hasUnread ? '$count nuevas' : 'Al día',
        style: textTheme.labelSmall?.copyWith(
          color: hasUnread
              ? colorScheme.onTertiary
              : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.state, required this.onFilterSelected});

  final NotificationsState state;
  final ValueChanged<AlertsFilter> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FilterChip(
          label: 'Todas',
          count: state.notifications.length,
          selected: state.filter == AlertsFilter.all,
          accentCount: false,
          onTap: () => onFilterSelected(AlertsFilter.all),
        ),
        const SizedBox(width: Insets.small),
        _FilterChip(
          label: 'Sin leer',
          count: state.unreadCount,
          selected: state.filter == AlertsFilter.unread,
          accentCount: true,
          onTap: () => onFilterSelected(AlertsFilter.unread),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.accentCount,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final bool accentCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final foreground = selected ? colorScheme.onPrimary : colorScheme.onSurface;
    final highlightCount = accentCount && count > 0 && !selected;

    return Material(
      color: selected ? colorScheme.primary : colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(999),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: textTheme.labelLarge?.copyWith(color: foreground),
              ),
              const SizedBox(width: Insets.xsmall),
              Text(
                '($count)',
                style: textTheme.labelLarge?.copyWith(
                  color: highlightCount ? colorScheme.tertiary : foreground,
                  fontWeight: highlightCount ? FontWeight.bold : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.notification,
    required this.isUnread,
    required this.onRegisterWatering,
    required this.onMarkAsRead,
    required this.onDismiss,
  });

  final AppNotification notification;
  final bool isUnread;
  final VoidCallback onRegisterWatering;
  final VoidCallback onMarkAsRead;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(Insets.medium),
      decoration: BoxDecoration(
        color: isUnread
            ? colorScheme.surfaceContainerHigh
            : colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.surfaceContainerHighest),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A432C).withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NotificationThumbnail(imageUrl: notification.imageUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (isUnread) ...[
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: colorScheme.tertiary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Expanded(
                          child: Text(
                            notification.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleSmall?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: Insets.small),
                        Text(
                          formatRelativeTime(notification.sentDate),
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Insets.xsmall),
                    Text(
                      notification.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: Insets.small),
                    _MoistureIndicator(
                      level: _moistureLevel(notification.data),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: Insets.small),
          Row(
            children: [
              FilledButton.icon(
                onPressed: onRegisterWatering,
                icon: const Icon(Symbols.water_drop, size: 16),
                label: const Text('Registrar Riego'),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: textTheme.labelLarge,
                ),
              ),
              const Spacer(),
              _CardAction(
                icon: Symbols.check_circle,
                tooltip: 'Marcar como leída',
                onPressed: onMarkAsRead,
              ),
              _CardAction(
                icon: Symbols.delete_sweep,
                tooltip: 'Descartar',
                onPressed: onDismiss,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardAction extends StatelessWidget {
  const _CardAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, size: 20, fill: 0),
      color: colorScheme.outline,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 36, height: 36),
    );
  }
}

class _NotificationThumbnail extends StatelessWidget {
  const _NotificationThumbnail({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final url = imageUrl?.trim();
    final hasImage = url != null && url.isNotEmpty;

    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: hasImage
                ? CachedNetworkImage(
                    imageUrl: url,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        _placeholder(colorScheme),
                    placeholder: (context, url) => _placeholder(colorScheme),
                  )
                : _placeholder(colorScheme),
          ),
          Positioned(
            right: -4,
            bottom: -4,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: colorScheme.tertiary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Symbols.water_drop,
                size: 14,
                color: colorScheme.onTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(ColorScheme colorScheme) {
    return Container(
      width: 56,
      height: 56,
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.local_florist,
        size: 24,
        color: colorScheme.outlineVariant,
      ),
    );
  }
}

class _MoistureIndicator extends StatelessWidget {
  const _MoistureIndicator({required this.level});

  final String? level;

  @override
  Widget build(BuildContext context) {
    final value = level?.trim();
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final (Color color, double fraction, String label) = switch (value
        .toLowerCase()) {
      'low' || 'bajo' => (colorScheme.tertiary, 0.25, 'Nivel bajo'),
      'medium' || 'medio' => (colorScheme.primary, 0.5, 'Nivel medio'),
      'high' || 'alto' => (colorScheme.secondary, 0.8, 'Nivel alto'),
      _ => (colorScheme.primary, 0.5, value),
    };

    return Row(
      children: [
        SizedBox(
          width: 96,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 6,
              backgroundColor: colorScheme.outlineVariant.withValues(
                alpha: 0.3,
              ),
              color: color,
            ),
          ),
        ),
        const SizedBox(width: Insets.small),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(Insets.large),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Symbols.sentiment_satisfied,
              size: 32,
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '¡Todo en orden!',
            style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: Insets.xsmall),
          Text(
            'Tus suculentas están felices, hidratadas y con luz perfecta. '
            'Te avisaremos cuando requieran atención.',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
          ),
        ],
      ),
    );
  }
}

class _CleanupBar extends StatelessWidget {
  const _CleanupBar({
    required this.hasReadNotifications,
    required this.onClearRead,
  });

  final bool hasReadNotifications;
  final VoidCallback onClearRead;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton.icon(
          onPressed: hasReadNotifications ? onClearRead : null,
          icon: const Icon(Symbols.clear_all, size: 16),
          label: const Text('Limpiar leídas'),
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.secondary,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            textStyle: textTheme.labelSmall,
          ),
        ),
      ],
    );
  }
}

class _AlertsErrorState extends StatelessWidget {
  const _AlertsErrorState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No pudimos cargar tus alertas.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

String? _moistureLevel(Map<String, dynamic>? data) {
  final value = data?['moistureLevel'];
  return value?.toString();
}
