import 'package:chat_application/common/const/url_cont.dart';
import 'package:chat_application/features/auth/otp_confirm/data/model/otp_confirm_model.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class OtpConfirmService {
  final Dio _dio = GetIt.I.get();
  Future<OtpConfirmModel> emailVerify(
      {required String email, required String otpCode}) async {
    final resp = await _dio.post(UrlConst.emailVerify, data: {
      'email': email,
      'otp': otpCode,
    });
    return OtpConfirmModel.fromJson(resp.data);
  }
}
