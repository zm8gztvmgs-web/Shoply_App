import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply_app/core/model/categories/ressponse_categories.dart';
import 'package:shoply_app/core/model/products/response_products.dart';
import 'package:shoply_app/core/model/sales/response_sales.dart';
import 'package:shoply_app/features/home/repo/home_repo.dart';
import 'package:shoply_app/features/home/view_model/state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitState());

  final _homeRepo = HomeRepo();

  ResponseSales? responseSales;
  final List<RessponseCategories> ressponseCategories = [];
  final List<ResponseProducts> responseProducts = [];

  String? _errorMessage;

  Future<void> refreshData() async {
    if (isClosed) return;

    responseSales = null;
    ressponseCategories.clear();
    responseProducts.clear();
    _errorMessage = null;

    await getHome();
  }

  Future<void> getHome() async {
    if (isClosed) return;

    _errorMessage = null;
    emit(HomeLoadingState());

    await Future.wait([_getSales(), _getCategories(), _getTrendingProducts()]);

    // Don't emit after the Cubit has been closed.
    if (isClosed) return;

    if (_errorMessage != null) {
      emit(HomeErrorState(errorMessage: _errorMessage ?? ''));
    } else {
      emit(HomeSuccessState());
    }
  }

  Future<void> _getSales() async {
    final result = await _homeRepo.getSales();

    if (isClosed) return;

    result.fold(
      (errorMessage) {
        _errorMessage = errorMessage;
      },
      (sales) {
        responseSales = sales;
      },
    );
  }

  Future<void> _getCategories() async {
    final result = await _homeRepo.getCategories();

    if (isClosed) return;

    result.fold(
      (errorMessage) {
        _errorMessage = errorMessage;
      },
      (categories) {
        final categoryOrder = ['shoes', 'clothes', 'bags', 'accessories'];

        final sortedCategories = List<RessponseCategories>.from(categories);

        sortedCategories.sort((a, b) {
          final aIndex = categoryOrder.indexOf(
            (a.name ?? '').trim().toLowerCase(),
          );

          final bIndex = categoryOrder.indexOf(
            (b.name ?? '').trim().toLowerCase(),
          );

          final aPosition = aIndex == -1 ? categoryOrder.length : aIndex;

          final bPosition = bIndex == -1 ? categoryOrder.length : bIndex;

          return aPosition.compareTo(bPosition);
        });

        ressponseCategories
          ..clear()
          ..addAll(sortedCategories);
      },
    );
  }

  Future<void> _getTrendingProducts() async {
    final result = await _homeRepo.getTrendingProducts();

    if (isClosed) return;

    result.fold(
      (errorMessage) {
        _errorMessage = errorMessage;
      },
      (products) {
        responseProducts
          ..clear()
          ..addAll(products);
      },
    );
  }
}
