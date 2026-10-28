import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply_app/core/model/categories/ressponse_categories.dart';
import 'package:shoply_app/features/categories/repo/categories_repo.dart';
import 'package:shoply_app/features/categories/view_model/state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(CategoriesInitState());

  final _categoriesRepo = CategoriesRepo();
  final List<RessponseCategories> ressponseCategories = [];

  Future<void> refreshCategories() async {
    await getCategories();
  }

  Future<void> getCategories() async {
    emit(CategoriesLoadingState());

    final result = await _categoriesRepo.getCategories();

    result.fold(
      (errorMessage) {
        emit(CategoriesErrorState(errorMessage: errorMessage));
      },
      (categories) {
        final categoryOrder = [
          'shoes',
          'clothes',
          'bags',
          'beauty',
          'electronics',
          'accessories',
        ];

        categories.sort((a, b) {
          final aIndex = categoryOrder.indexOf(
            (a.name ?? '').trim().toLowerCase(),
          );

          final bIndex = categoryOrder.indexOf(
            (b.name ?? '').trim().toLowerCase(),
          );

          return (aIndex == -1 ? 999 : aIndex).compareTo(
            bIndex == -1 ? 999 : bIndex,
          );
        });

        ressponseCategories
          ..clear()
          ..addAll(categories);

        emit(CategoriesSuccessState());
      },
    );
  }
}
