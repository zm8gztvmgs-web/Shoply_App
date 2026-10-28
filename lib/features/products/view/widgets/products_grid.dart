part of '../products_screen.dart';

class _ProductsGrid extends StatelessWidget {
  const _ProductsGrid();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductsCubit>();

    return GridView.builder(
      itemCount: cubit.responseProducts.length,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 235,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        final product = cubit.responseProducts[index];

        return _ProductCard(
          key: ValueKey(product.id ?? index),
          product: product,
        );
      },
    );
  }
}

class _ProductCard extends StatefulWidget {
  const _ProductCard({super.key, required this.product});

  final ResponseProducts product;

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  final ProductDetailsRepo _repo = ProductDetailsRepo();

  bool _isFavourite = false;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _checkFavourite();
  }

  Future<void> _checkFavourite() async {
    final productId = widget.product.id;

    if (productId == null || productId.isEmpty) return;

    final result = await _repo.checkIfProductInFavourite(productId: productId);

    if (!mounted) return;

    result.fold((_) {}, (isFavourite) {
      setState(() {
        _isFavourite = isFavourite;
      });
    });
  }

  Future<void> _toggleFavourite() async {
    final product = widget.product;
    final productId = product.id;

    if (productId == null || productId.isEmpty || _isUpdating) {
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    final wasFavourite = _isFavourite;

    final result = wasFavourite
        ? await _repo.removeToFavourite(productId: productId)
        : await _repo.addToFavourite(
            requestProducts: RequestProducts(
              id: product.id,
              name: product.name,
              description: product.description,
              price: product.price,
              images: product.images,
            ),
          );

    if (!mounted) return;

    result.fold(
      (errorMessage) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      },
      (success) {
        if (success) {
          setState(() {
            _isFavourite = !wasFavourite;
          });

          final mainCubit = context.read<MainCubit>();

          if (_isFavourite) {
            mainCubit.incrementFavouriteCount();
          } else {
            mainCubit.decrementFavouriteCount();
          }
        }
      },
    );

    if (mounted) {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppPages.productsDetailsScreen,
          arguments: {'responseProducts': product, 'context': context},
        ).then((_) {
          if (mounted) {
            _checkFavourite();
          }
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 155,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.shade100,
                ),
                child: product.images.isNotEmpty
                    ? CustomCachedImageNetwork(
                        fit: BoxFit.contain,
                        image: product.images.first,
                      )
                    : const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey,
                        ),
                      ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  onPressed: _isUpdating ? null : _toggleFavourite,
                  icon: Icon(
                    _isFavourite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavourite ? Colors.red : Colors.black87,
                    size: 23,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              product.name ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 6),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '\$ ${product.price ?? ''}',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
