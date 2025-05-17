import 'package:chat_application/features/auth/sign_up/data/models/otp_request.dart';
import 'package:chat_application/features/auth/sign_up/data/models/signup_model.dart';
import 'package:chat_application/features/auth/sign_up/data/services/signup_service.dart';
import 'package:chat_application/features/auth/sign_up/notifier/signup_state_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef SignupProvider = NotifierProvider<SignupNotifier, SignupStateModel>;

class SignupNotifier extends Notifier<SignupStateModel> {
  final SignupService _service = SignupService();
  @override
  SignupStateModel build() {
    return SignupStateModel(
      isLoading: false,
    );
  }

  void tryAgain() {
    state = state.copyWith(
      isLoading: false,
      isFailed: false,
      isSuccess: false,
    );
  }

  void signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(
        isLoading: true,
        isSuccess: false,
        isFailed: false,
      );
      SignupModel signupModel = await _service.signup(
        name: name,
        email: email,
        password: password,
      );
      state = state.copyWith(
        isSuccess: true,
        isLoading: false,
        model: signupModel,
      );
    } catch (e) {
      //verify => Email is already verified.
      //new account => OTP already sent.
      if (e is DioException) {
        final errorResponse = e.response?.data;
        if (errorResponse is Map && errorResponse['message'] != null) {
          state = state.copyWith(
              isLoading: false,
              isFailed: true,
              errorMessage: errorResponse['message']);
        } else {
          state = state.copyWith(
            isLoading: false,
            isFailed: true,
            errorMessage: 'Unknown error',
          );
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          isFailed: true,
          errorMessage: 'Unknown error',
        );
      }
    }
  }

  void otpRequest(String email) async {
    try {
      state = state.copyWith(
        isLoading: true,
        isSuccess: false,
        isFailed: false,
      );
      await _service.otpRequest(email: email);
      state = state = state.copyWith(
        isSuccess: true,
        isLoading: false,
      );
    } catch (e) {
      state = state = state.copyWith(
        isLoading: false,
        isFailed: true,
        errorMessage: 'Unknown error',
      );
    }
  }

  String failedButtonText(String errorMessage) {
    if (errorMessage == 'OTP already sent.') {
      return "Send Again";
    } else if (errorMessage == 'Email is already verified.') {
      return "Login";
    }
    return 'Try Again';
  }
}
