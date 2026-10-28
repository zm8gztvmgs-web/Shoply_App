part of '../home_screen.dart';

class _HomeTrendingProducts extends StatelessWidget {
  const _HomeTrendingProducts();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();

    return Column(
      children: [
        CustomViewAll(text: 'Trending Products', onTapViewAll: () {}),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cubit.responseProducts.length,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 220,
            crossAxisSpacing: 30,
          ),
          itemBuilder: (context, index) {
            final product = cubit.responseProducts[index];

            return _TrendingProductCard(
              key: ValueKey(product.id ?? index),
              product: product,
            );
          },
        ),
      ],
    );
  }
}

class _TrendingProductCard extends StatefulWidget {
  const _TrendingProductCard({super.key, required this.product});

  final ResponseProducts product;

  @override
  State<_TrendingProductCard> createState() => _TrendingProductCardState();
}

class _TrendingProductCardState extends State<_TrendingProductCard> {
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
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.shade200,
                ),
                child: CustomCachedImageNetwork(
                  fit: BoxFit.contain,
                  image: product.images.isNotEmpty ? product.images[0] : '',
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
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
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              product.name ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '\$ ${product.price}',
              style: const TextStyle(
                fontSize: 18,
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
