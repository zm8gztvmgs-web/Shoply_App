part of '../favourite_screen.dart';

class _FavouriteGrid extends StatelessWidget {
  const _FavouriteGrid();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FavouriteCubit>();

    return GridView.builder(
      itemCount: cubit.responseProducts.length,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 300,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final favouriteData = cubit.responseProducts[index];

        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 135,
                width: double.infinity,
                child: Container(
                  color: Colors.grey.shade100,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CustomCachedImageNetwork(
                        fit: BoxFit.contain,
                        image: favouriteData.images.isNotEmpty
                            ? favouriteData.images.first
                            : '',
                      ),
                      Positioned(
                        top: 8,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            cubit.removeProductFromFav(
                              context: context,
                              productId: favouriteData.id ?? '',
                            );
                          },
                          child: const Icon(
                            Icons.favorite,
                            size: 28,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  favouriteData.name ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '\$ ${favouriteData.price}',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
                child: CustomButton(
                  radius: 12,
                  height: 45,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                  buttonText: 'Add to Cart',
                  onPressed: () {
                    cubit.addToCart(
                      requestCart: Cart(
                        id: favouriteData.id,
                        name: favouriteData.name,
                        price: favouriteData.price,
                        quantity: 1,
                        images: favouriteData.images,
                      ),
                      context: context,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
