import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply_app/core/routes/app_pages.dart';
import 'package:shoply_app/core/utils/theme/app_colors.dart';
import 'package:shoply_app/features/main/view_model/cubit.dart';
import 'package:shoply_app/features/main/view_model/state.dart';

class SharedBottomNavBar extends StatelessWidget {
  const SharedBottomNavBar({super.key});

  void _navigateToTab(BuildContext context, int index) {
    context.read<MainCubit>().changeNavBarIndex(index: index);

    Navigator.of(context).popUntil(
      (route) => route.settings.name == AppPages.mainScreen || route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        final cubit = context.read<MainCubit>();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(height: 1, thickness: 0.4, color: Colors.grey),
            NavigationBar(
              labelTextStyle: WidgetStatePropertyAll(theme.textTheme.bodySmall),
              selectedIndex: cubit.navBarIndex,
              onDestinationSelected: (index) {
                _navigateToTab(context, index);
              },
              indicatorShape: const CircleBorder(),
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined, color: theme.iconTheme.color),
                  selectedIcon: const Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.grid_view_outlined,
                    color: theme.iconTheme.color,
                  ),
                  selectedIcon: const Icon(Icons.grid_view),
                  label: 'Categories',
                ),
                NavigationDestination(
                  icon: Badge(
                    padding: const EdgeInsets.all(1),
                    offset: const Offset(4, -8),
                    backgroundColor: AppColors.primaryColor,
                    label: Text(
                      '${cubit.favouriteCount}',
                      style: theme.textTheme.bodySmall,
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      color: theme.iconTheme.color,
                    ),
                  ),
                  selectedIcon: Badge(
                    padding: const EdgeInsets.all(1),
                    offset: const Offset(6, -10),
                    backgroundColor: AppColors.primaryColor,
                    label: Text(
                      '${cubit.favouriteCount}',
                      style: theme.textTheme.bodySmall,
                    ),
                    child: const Icon(Icons.favorite),
                  ),
                  label: 'Favorite',
                ),
                NavigationDestination(
                  icon: Badge(
                    padding: const EdgeInsets.all(1),
                    offset: const Offset(4, -8),
                    backgroundColor: AppColors.primaryColor,
                    label: Text(
                      '${cubit.cartCount}',
                      style: theme.textTheme.bodySmall,
                    ),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: theme.iconTheme.color,
                    ),
                  ),
                  selectedIcon: Badge(
                    padding: const EdgeInsets.all(1),
                    offset: const Offset(6, -10),
                    backgroundColor: AppColors.primaryColor,
                    label: Text(
                      '${cubit.cartCount}',
                      style: theme.textTheme.bodySmall,
                    ),
                    child: const Icon(Icons.shopping_cart),
                  ),
                  label: 'Cart',
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
