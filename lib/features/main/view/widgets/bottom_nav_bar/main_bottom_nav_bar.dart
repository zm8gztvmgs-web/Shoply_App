part of '../../main_screen.dart';

class _MainBottomNavBar extends StatelessWidget {
  const _MainBottomNavBar();

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
                cubit.changeNavBarIndex(index: index);
              },
              indicatorShape: CircleBorder(),
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined, color: theme.iconTheme.color),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.grid_view_outlined,
                    color: theme.iconTheme.color,
                  ),
                  selectedIcon: Icon(Icons.grid_view),
                  label: 'Categories',
                ),
                NavigationDestination(
                  icon: Badge(
                    padding: EdgeInsets.all(1),
                    offset: Offset(4, -8),
                    backgroundColor: AppColors.primaryColor,
                    label: Center(
                      child: Text(
                        '${cubit.favouriteCount}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      color: theme.iconTheme.color,
                    ),
                  ),
                  selectedIcon: Badge(
                    padding: EdgeInsets.all(1),
                    offset: Offset(6, -10),
                    backgroundColor: AppColors.primaryColor,
                    label: Center(
                      child: Text(
                        '${cubit.favouriteCount}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    child: Icon(Icons.favorite),
                  ),
                  label: 'Favorite',
                ),

                NavigationDestination(
                  icon: Badge(
                    padding: EdgeInsets.all(1),
                    offset: Offset(4, -8),
                    backgroundColor: AppColors.primaryColor,
                    label: Center(
                      child: Text(
                        '${cubit.cartCount}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: theme.iconTheme.color,
                    ),
                  ),
                  selectedIcon: Badge(
                    padding: EdgeInsets.all(1),
                    offset: Offset(6, -10),
                    backgroundColor: AppColors.primaryColor,
                    label: Center(
                      child: Text(
                        '${cubit.cartCount}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    child: Icon(Icons.shopping_cart),
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
