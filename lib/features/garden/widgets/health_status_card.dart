import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:succucare_app/core/theme/app_colors.dart';
import 'package:succucare_app/features/garden/models/models.dart';

class HealthStatusCard extends StatelessWidget {
  const HealthStatusCard({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.needsWater,
    required this.onNeedsWaterChanged,
    required this.lightingChange,
    required this.onLightingChanged,
    required this.repotting,
    required this.onRepottingChanged,
  });

  final HealthStatus? selectedStatus;
  final ValueChanged<HealthStatus> onStatusChanged;
  final bool needsWater;
  final ValueChanged<bool> onNeedsWaterChanged;
  final bool lightingChange;
  final ValueChanged<bool> onLightingChanged;
  final bool repotting;
  final ValueChanged<bool> onRepottingChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Symbols.vital_signs, size: 16, color: AppColors.mysticMaroon),
              const SizedBox(width: 6),
              Text(
                'ESTADO DE SALUD',
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.08,
                  color: AppColors.rocketMetallic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Condición de la Planta',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.5,
            children: [
              _HealthStatusTile(
                status: HealthStatus.healthy,
                label: 'Saludable',
                subtitle: 'En optimo estado',
                color: const Color(0xFF10B981),
                selected: selectedStatus == HealthStatus.healthy,
                onTap: () => onStatusChanged(HealthStatus.healthy),
              ),
              _HealthStatusTile(
                status: HealthStatus.sick,
                label: 'Enferma',
                subtitle: 'Plagas o daños',
                color: const Color(0xFFF87171),
                selected: selectedStatus == HealthStatus.sick,
                onTap: () => onStatusChanged(HealthStatus.sick),
              ),
              _HealthStatusTile(
                status: HealthStatus.recovering,
                label: 'Recuperación',
                subtitle: 'En tratamiento',
                color: const Color(0xFFFBBF24),
                selected: selectedStatus == HealthStatus.recovering,
                onTap: () => onStatusChanged(HealthStatus.recovering),
              ),
              _HealthStatusTile(
                status: HealthStatus.dormant,
                label: 'Inactiva',
                subtitle: 'Inactiva',
                color: const Color(0xFF60A5FA),
                selected: selectedStatus == HealthStatus.dormant,
                onTap: () => onStatusChanged(HealthStatus.dormant),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Text(
            'ACCIONES INMEDIATAS REQUERIDAS',
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.08,
              color: AppColors.rocketMetallic,
            ),
          ),
          const SizedBox(height: 8),
          _ActionToggleRow(
            icon: Icons.opacity,
            iconColor: const Color(0xFF0284C7),
            iconBg: const Color(0xFFE0F2FE),
            title: 'Necesita agua',
            subtitle: 'Requiere riego inmediato',
            value: needsWater,
            onChanged: onNeedsWaterChanged,
          ),
          const SizedBox(height: 8),
          _ActionToggleRow(
            icon: Icons.wb_sunny,
            iconColor: const Color(0xFFD97706),
            iconBg: const Color(0xFFFEF3C7),
            title: 'Cambio de luz',
            subtitle: 'Reubicar por necesidad lumínica',
            value: lightingChange,
            onChanged: onLightingChanged,
          ),
          const SizedBox(height: 8),
          _ActionToggleRow(
            icon: Icons.eco,
            iconColor: const Color(0xFFEA580C),
            iconBg: const Color(0xFFFFEDD5),
            title: 'Trasplantar',
            subtitle: 'Necesita cambio o refresco de maceta',
            value: repotting,
            onChanged: onRepottingChanged,
          ),
        ],
      ),
    );
  }
}

class _HealthStatusTile extends StatelessWidget {
  const _HealthStatusTile({
    required this.status,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final HealthStatus status;
  final String label;
  final String subtitle;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        height: 25.0,
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.1)
              : const Color(0xFFF8F9FB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color.withValues(alpha: 0.8) : colorScheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: selected ? color : colorScheme.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: selected ? color : colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionToggleRow extends StatelessWidget {
  const _ActionToggleRow({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
