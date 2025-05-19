import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState.initial());

  Future<void> checkAuthentication() async {
    emit(const SplashState.loading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      final userId = prefs.getInt("userId");
      await Future.delayed(const Duration(seconds: 3));

      if (token != null && token.isNotEmpty && userId != null) {
        // Có token và userId ⇒ Đã đăng nhập
        emit(const SplashState.authenticated());
      } else {
        // Không có ⇒ chưa đăng nhập
        emit(const SplashState.unauthenticated());
      }
    } catch (e) {
      emit(SplashState.error("Lỗi kiểm tra đăng nhập: $e"));
    }
  }
}
