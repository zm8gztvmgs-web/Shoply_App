import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply_app/core/local/local_storage.dart';
import 'package:shoply_app/core/local/local_storage_user.dart';
import 'package:shoply_app/features/splash/view_model/state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitState());

  Future<void> goNextPage() async {
    final bool isShowOnBoard = LocalStorage.instance.getShowOnBoard() ?? false;

    final bool isLogin = LocalStorage.instance.getIsLogin() ?? false;

    await Future.delayed(const Duration(seconds: 1));

    if (isClosed) return;

    if (isShowOnBoard) {
      if (isLogin) {
        final responseLogin = await LocalStorageUser.instance.getUserData();

        if (isClosed) return;

        LocalStorageUser.instance.setUserinfo(responseLogin: responseLogin);

        emit(SplashMainPageState());
      } else {
        emit(SplashLoginPageState());
      }
    } else {
      await LocalStorageUser.instance.clearUserData();

      if (isClosed) return;

      emit(SplashOnBoardPageState());
    }
  }
}
