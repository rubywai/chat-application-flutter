import '../data/models/message_model.dart';

class ChatDetailStateModel {
  final bool isLoading;
  final bool isFailed;
  final bool isSuccess;
  final MessageModel messageModel;
  final List<String> tempSendMessage;
  final List<String> tempRecMessage;

  ChatDetailStateModel({
    required this.messageModel,
    this.isLoading = true,
    this.isFailed = false,
    this.isSuccess = false,
    this.tempSendMessage = const [],
    this.tempRecMessage = const [],
  });

  ChatDetailStateModel copyWith({
    MessageModel? messageModel,
    bool? isLoading,
    bool? isFailed,
    bool? isSuccess,
    List<String>? tempSendMessage,
    List<String>? tempRecMessage,
  }) {
    return ChatDetailStateModel(
      messageModel: messageModel ?? this.messageModel,
      isLoading: isLoading ?? this.isLoading,
      isFailed: isFailed ?? this.isFailed,
      isSuccess: isSuccess ?? this.isSuccess,
      tempSendMessage: tempSendMessage ?? this.tempSendMessage,
      tempRecMessage: tempRecMessage ?? this.tempRecMessage,
    );
  }
}
