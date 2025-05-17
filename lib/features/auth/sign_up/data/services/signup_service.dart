import 'package:chat_application/features/auth/sign_up/data/models/otp_request.dart';
import 'package:dio/dio.dart';

import '../../../../../common/const/url_cont.dart';
import '../../../../../di/locator.dart';
import '../models/signup_model.dart';

class SignupService {
  final Dio _dio = getIt.get();
  Future<SignupModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final resp = await _dio.post(
      UrlConst.signup,
      data: {
        'email': email,
        'name': name,
        'password': password,
      },
    );
    return SignupModel.fromJson(resp.data);
  }

  Future<OtpRequest> otpRequest({
    required String email,
  }) async {
    final resp = await _dio.post(
      UrlConst.otpRequest,
      data: {"email": email},
    );
    return OtpRequest.fromJson(resp.data);
  }
}
