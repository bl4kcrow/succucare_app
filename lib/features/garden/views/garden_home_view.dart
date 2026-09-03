import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../widgets/widgets.dart';

class GardenHomeView extends ConsumerStatefulWidget {
  const GardenHomeView({super.key});

  @override
  ConsumerState<GardenHomeView> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<GardenHomeView> {
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final homeViewModel = ref.read(homeViewModelProvider.notifier);
    final homeState = ref.watch(homeViewModelProvider);
    final plants = ref.watch(filteredPlantsProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 96),
          physics: const ClampingScrollPhysics(),
          children: [
            GardenSearchField(
              focusNode: _searchFocusNode,
              onChanged: homeViewModel.updateQuery,
            ),
            const SizedBox(height: 16),
            CategoryFilterBar(
              selected: homeState.selectedCategory,
              onSelected: homeViewModel.selectCategory,
            ),
            const SizedBox(height: 24),
            GardenHeader(plantCount: plants.length),
            const SizedBox(height: 16),
            if (plants.isEmpty)
              _EmptyGarden(query: homeState.query)
            else
              for (final plant in plants)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: PlantCard(
                    plant: plant,
                    onTap: () => _showComingSoon(plant.name),
                    onWaterPressed: () => _showComingSoon('Watering'),
                  ),
                ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showComingSoon('Add plant'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}

class _EmptyGarden extends StatelessWidget {
  const _EmptyGarden({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.yard, size: 48, color: colorScheme.outlineVariant),
          const SizedBox(height: 12),
          Text(
            query.isEmpty
                ? 'No plants here yet'
                : 'No plants match your search',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
