part of '../categories_screen.dart';

class _CategoriesCard extends StatelessWidget {
  const _CategoriesCard();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CategoriesCubit>();

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      itemCount: cubit.ressponseCategories.length,
      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },
      itemBuilder: (context, index) {
        final categoriesData = cubit.ressponseCategories[index];
        final categoryName = categoriesData.name ?? '';

        final displayName = categoryName.isEmpty
            ? ''
            : categoryName[0].toUpperCase() + categoryName.substring(1);

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppPages.productsScreen,
              arguments: {
                'titleText': displayName,
                'categoryId': categoriesData.id,
                'context': context,
              },
            );
          },
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: CustomCachedImageNetwork(
                    height: 74,
                    width: 90,
                    fit: BoxFit.contain,
                    image: categoriesData.image ?? '',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.black87,
                ),
                const SizedBox(width: 18),
              ],
            ),
          ),
        );
      },
    );
  }
}
