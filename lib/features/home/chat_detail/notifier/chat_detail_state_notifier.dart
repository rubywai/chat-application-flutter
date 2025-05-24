import 'package:chat_application/features/home/chat_detail/data/models/message_model.dart';
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

  void getAllMessage(String chatId) async {
    try {
      state = state.copyWith(
        isSuccess: false,
        isFailed: false,
        isLoading: true,
      );
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
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required String content,
  }) async {
    try {
      _service.sendMessage(
        chatId: chatId,
        content: content,
      );
    } catch (e) {
      return Future.error(e);
    }
  }
}
