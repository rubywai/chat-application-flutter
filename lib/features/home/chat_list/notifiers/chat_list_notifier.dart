import 'package:chat_application/features/home/chat_list/data/models/chat_list_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/chat_list_services.dart';
import 'chat_list_state_model.dart';

typedef ChatListProvider
    = NotifierProvider<ChatListNotifier, ChatListStateModel>;

class ChatListNotifier extends Notifier<ChatListStateModel> {
  final ChatListService _chatListService = ChatListService();
  @override
  build() {
    return ChatListStateModel();
  }

  void getChatList({bool loading = true}) async {
    try {
      if (loading) {
        state = state.copyWith(
          isFailed: false,
          isSuccess: false,
          isLoading: true,
        );
      }
      ChatListModel chatListModel = await _chatListService.getChatList();
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        chatListModel: chatListModel,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isFailed: true,
      );
    }
  }
}
