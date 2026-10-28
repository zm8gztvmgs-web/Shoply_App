part of '../product_details_screen.dart';

class _ProductDetailsBottom extends StatelessWidget {
  const _ProductDetailsBottom({required this.responseProducts});

  final ResponseProducts responseProducts;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductDetailsCubit>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            width: 160,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      cubit.decrementQuantity();
                    },
                    icon: const Icon(Icons.remove, size: 22),
                  ),
                ),
                Expanded(
                  child: Center(
                    child:
                        BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                          buildWhen: (previous, current) {
                            return current is ProductDetailsChangeQuantityState;
                          },
                          builder: (context, state) {
                            return Text(
                              cubit.quantity.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            );
                          },
                        ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      cubit.incrementQuantity();
                    },
                    icon: const Icon(Icons.add, size: 22),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: CustomButton(
              buttonText: 'Add to Cart',
              onPressed: () {
                cubit.addToCart(
                  context: context,
                  requestCart: Cart(
                    id: responseProducts.id,
                    name: responseProducts.name,
                    price: responseProducts.price,
                    quantity: cubit.quantity,
                    images: responseProducts.images,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
