part of '../product_details_screen.dart';

class _ProductDetailsTop extends StatelessWidget {
  const _ProductDetailsTop({required this.responseProducts});

  final ResponseProducts responseProducts;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductDetailsCubit>();

    return Column(
      children: [
        SizedBox(
          height: 280,
          width: double.infinity,
          child: PageView.builder(
            controller: cubit.pageController,
            itemCount: responseProducts.images.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomCachedImageNetwork(
                  fit: BoxFit.contain,
                  image: responseProducts.images[index],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        CustomSmoothIndicator(
          pageController: cubit.pageController,
          count: responseProducts.images.length,
        ),
      ],
    );
  }
}
