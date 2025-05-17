import 'package:chat_application/features/auth/otp_confirm/data/service/otp_confirm_service.dart';
import 'package:chat_application/features/auth/otp_confirm/notifier/otp_confirm_state_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef OtpConfirmProvider
    = NotifierProvider<OtpConfirmNotifier, OtpConfirmStateModel>;

class OtpConfirmNotifier extends Notifier<OtpConfirmStateModel> {
  final OtpConfirmService _service = OtpConfirmService();
  @override
  OtpConfirmStateModel build() {
    return OtpConfirmStateModel(
      isLoading: false,
      isSuccess: false,
      isFailed: false,
    );
  }

  void tryAgain() {
    state = state.copyWith(
      isLoading: false,
      isSuccess: false,
      isFailed: false,
    );
  }

  void verifyEmail({
    required String email,
    required String otpCode,
  }) async {
    try {
      state = state.copyWith(
        isSuccess: false,
        isFailed: false,
        isLoading: true,
      );
      await _service.emailVerify(email: email, otpCode: otpCode);
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isFailed: true,
      );
    }
  }
}
