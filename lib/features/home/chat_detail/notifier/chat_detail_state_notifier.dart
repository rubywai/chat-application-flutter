import 'package:chat_application/features/home/chat_detail/data/models/message_model.dart';
import 'package:chat_application/features/home/chat_detail/data/models/send_message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/chat_detail_service.dart';
import 'chat_detail_state_model.dart';

typedef ChatDetailProvider
    = NotifierProvider<ChatDetailStateNotifier, ChatDetailStateModel>;

class ChatDetailStateNotifier extends Notifier<ChatDetailStateModel> {
  final ChatDetailService _service = ChatDetailService();
  @override
  ChatDetailStateModel build() {
    return ChatDetailStateModel(
      messageModel: MessageModel(),
    );
  }

  void addTemSendMessage(String message) {
    state = state.copyWith(tempSendMessage: [...state.tempRecMessage, message]);
  }

  void addTemReceiveMessage(String message) {
    state = state.copyWith(tempRecMessage: [...state.tempRecMessage, message]);
  }

  void getAllMessage(String chatId, {bool showLoading = true}) async {
    try {
      if (showLoading) {
        state = state.copyWith(
          isSuccess: false,
          isFailed: false,
          isLoading: true,
        );
      }
      MessageModel messageModel = await _service.getAllMessage(chatId: chatId);
      state = state.copyWith(
        messageModel: messageModel,
        isLoading: false,
        isSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isFailed: false,
      );
    } finally {
      state = state.copyWith(
        tempRecMessage: [],
        tempSendMessage: [],
      );
    }
  }

  Future<Data?> sendMessage({
    required String chatId,
    required String content,
  }) async {
    try {
      SendMessageModel sendMessageModel = await _service.sendMessage(
        chatId: chatId,
        content: content,
      );
      return sendMessageModel.data;
    } catch (e) {
      return Future.error(e);
    }
  }
}
