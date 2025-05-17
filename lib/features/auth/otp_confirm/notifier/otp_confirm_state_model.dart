class OtpConfirmStateModel {
  final bool isLoading;
  final bool isSuccess;
  final bool isFailed;

  OtpConfirmStateModel({
    required this.isLoading,
    required this.isSuccess,
    required this.isFailed,
  });

  OtpConfirmStateModel copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isFailed,
  }) {
    return OtpConfirmStateModel(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailed: isFailed ?? this.isFailed,
    );
  }
}
