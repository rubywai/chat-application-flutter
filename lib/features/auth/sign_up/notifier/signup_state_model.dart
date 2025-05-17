import '../data/models/signup_model.dart';

class SignupStateModel {
  final bool isLoading;
  final bool isSuccess;
  final bool isFailed;
  final String errorMessage;
  final SignupModel? model;

  SignupStateModel({
    this.isLoading = false,
    this.isSuccess = false,
    this.isFailed = false,
    this.errorMessage = '',
    this.model,
  });

  SignupStateModel copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isFailed,
    String? errorMessage,
    SignupModel? model,
  }) {
    return SignupStateModel(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailed: isFailed ?? this.isFailed,
      errorMessage: errorMessage ?? this.errorMessage,
      model: model ?? this.model,
    );
  }
}
