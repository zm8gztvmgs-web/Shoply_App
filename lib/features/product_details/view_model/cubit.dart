import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply_app/core/model/cart/cart.dart';
import 'package:shoply_app/core/model/products/request_products.dart';
import 'package:shoply_app/core/model/products/response_products.dart';
import 'package:shoply_app/features/main/view_model/cubit.dart';
import 'package:shoply_app/features/product_details/repo/product_details_repo.dart';
import 'package:shoply_app/features/product_details/view_model/state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitState());

  final _productDetailsRepo = ProductDetailsRepo();
  final pageController = PageController();

  int quantity = 1;
  bool isFavourite = false;

  void incrementQuantity() {
    if (quantity < 10) {
      quantity++;
      emit(ProductDetailsChangeQuantityState());
    }
  }

  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
      emit(ProductDetailsChangeQuantityState());
    }
  }

  Future<void> addToCart({
    required Cart requestCart,
    required BuildContext context,
  }) async {
    emit(ProductDetailsAddToCartLoadingState());

    debugPrint('ADD TO CART START: ${requestCart.id}');

    try {
      final result = await _productDetailsRepo.addToCart(
        requestCart: requestCart,
      );

      result.fold(
        (errorMessage) {
          debugPrint('ADD TO CART ERROR: $errorMessage');

          if (!isClosed) {
            emit(ProductDetailsAddToCartErrorState(errorMessage: errorMessage));
          }
        },
        (_) {
          debugPrint('ADD TO CART SUCCESS: ${requestCart.id}');

          if (context.mounted) {
            context.read<MainCubit>().getCartCount();
          }

          if (!isClosed) {
            emit(ProductDetailsAddToCartSuccessState());
          }
        },
      );
    } catch (e) {
      debugPrint('ADD TO CART EXCEPTION: $e');

      if (!isClosed) {
        emit(ProductDetailsAddToCartErrorState(errorMessage: e.toString()));
      }
    }
  }

  Future<void> checkIfProductInFavourite({required String productId}) async {
    emit(ProductDetailsFavouriteLoadingState());

    final result = await _productDetailsRepo.checkIfProductInFavourite(
      productId: productId,
    );

    if (isClosed) return;

    result.fold(
      (errorMessage) {
        emit(ProductDetailsFavouriteErrorState(errorMessage: errorMessage));
      },
      (isFavourite) {
        this.isFavourite = isFavourite;
        emit(ProductDetailsFavouriteSucessState());
      },
    );
  }

  void changeIsFavourite({
    required ResponseProducts responseProducts,
    required BuildContext context,
  }) {
    isFavourite = !isFavourite;

    if (isFavourite) {
      context.read<MainCubit>().incrementFavouriteCount();

      _addToFavourite(responseProducts: responseProducts);
    } else {
      context.read<MainCubit>().decrementFavouriteCount();

      _removeToFavourite(productId: responseProducts.id ?? '');
    }

    emit(ProductDetailsChangeFavouriteState());
  }

  Future<void> _addToFavourite({
    required ResponseProducts responseProducts,
  }) async {
    await _productDetailsRepo.addToFavourite(
      requestProducts: RequestProducts(
        id: responseProducts.id,
        name: responseProducts.name,
        description: responseProducts.description,
        price: responseProducts.price,
        images: responseProducts.images,
      ),
    );
  }

  Future<void> _removeToFavourite({required String productId}) async {
    await _productDetailsRepo.removeToFavourite(productId: productId);
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
