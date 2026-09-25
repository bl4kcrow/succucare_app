import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:succucare_app/core/routes/routes.dart';
import 'package:succucare_app/core/theme/insets.dart';
import 'package:succucare_app/features/garden/providers/providers.dart';
import 'package:succucare_app/features/garden/widgets/widgets.dart';

class MyGardenHomeView extends ConsumerStatefulWidget {
  const MyGardenHomeView({super.key});

  @override
  ConsumerState<MyGardenHomeView> createState() => _MyGardenHomeViewState();
}

class _MyGardenHomeViewState extends ConsumerState<MyGardenHomeView> {
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        _scrollController.position.extentAfter < 300) {
      ref.read(myGardenProvider.notifier).loadNextPlants();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
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
    final myGarden = ref.watch(myGardenProvider);
    final myGardenNotifier = ref.read(myGardenProvider.notifier);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: myGarden.when(
          data: (myGarden) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: Insets.medium),
            child: Column(
              children: [
                GardenSearchField(
                  focusNode: _searchFocusNode,
                  onChanged: (value) => 'To Implement',
                ),
                const SizedBox(height: Insets.small),
                // CategoryFilterBar(
                //   selected: homeState.selectedCategory,
                //   onSelected: homeViewModel.selectCategory,
                // ),
                // const SizedBox(height: 24),
                GardenHeader(plantCount: myGarden.length),
                const SizedBox(height: Insets.small),
                if (myGarden.isEmpty)
                  _EmptyGarden(query: '')
                else
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          myGarden.length +
                          (myGardenNotifier.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= myGarden.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: Insets.small,
                            ),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          );
                        }
                        final plant = myGarden[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: Insets.medium),
                          child: PlantCard(
                            plant: plant,
                            onTap: () => context.pushNamed(
                              Routes.editPlant.name,
                              extra: plant,
                            ),
                            onWaterPressed: () => _showComingSoon('Watering'),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          error: (err, stack) => Text('Error: $err'),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(Routes.addPlant.name),
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
