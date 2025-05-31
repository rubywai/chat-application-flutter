import 'dart:math';

import 'package:chat_application/common/storage/app_storage.dart';
import 'package:chat_application/features/auth/login/data/model/login_model.dart';
import 'package:chat_application/features/auth/login/data/service/login_service.dart';
import 'package:chat_application/features/auth/login/notifier/login_state_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

typedef LoginProvider = NotifierProvider<LoginNotifier, LoginStateModel>;

class LoginNotifier extends Notifier<LoginStateModel> {
  final LoginService _loginService = LoginService();
  final AppStorage _storage = GetIt.I.get<AppStorage>();
  @override
  LoginStateModel build() {
    return LoginStateModel(
      isLoading: false,
      isSuccess: false,
      isFailed: false,
      loginModel: null,
    );
  }

  void tryAgain() {
    state = state.copyWith(
      isLoading: false,
      isSuccess: false,
      isFailed: false,
    );
  }

  void login({
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(
        isFailed: false,
        isSuccess: false,
        isLoading: true,
      );
      LoginModel loginModel = await _loginService.login(
        email: email,
        password: password,
      );
      _storage.saveToken(loginModel.data?.token ?? '');
      _storage.saveUserId(loginModel.data?.user?.id ?? '');
      _storage.saveUserName(loginModel.data?.user?.name ?? '');
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        loginModel: loginModel,
      );
    } catch (e) {
      if (e is DioException && e.response?.data['message'] != null) {
        state = state.copyWith(
          isLoading: false,
          isFailed: true,
          errorMessage: e.response?.data['message'],
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isFailed: true,
          errorMessage: "Failed to Login",
        );
      }
    }
  }
}
