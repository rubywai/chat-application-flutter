import '../data/models/message_model.dart';

class ChatDetailStateModel {
  final bool isLoading;
  final bool isFailed;
  final bool isSuccess;
  final MessageModel messageModel;

  ChatDetailStateModel({
    required this.messageModel,
    this.isLoading = true,
    this.isFailed = false,
    this.isSuccess = false,
  });

  ChatDetailStateModel copyWith({
    MessageModel? messageModel,
    bool? isLoading,
    bool? isFailed,
    bool? isSuccess,
  }) {
    return ChatDetailStateModel(
      messageModel: messageModel ?? this.messageModel,
      isLoading: isLoading ?? this.isLoading,
      isFailed: isFailed ?? this.isFailed,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
