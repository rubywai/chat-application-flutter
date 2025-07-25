import 'package:chat_application/common/storage/app_storage.dart';
import 'package:chat_application/common/theme/extension/color_neutral.dart';
import 'package:chat_application/common/theme/extension/meta_data_text_theme.dart';
import 'package:chat_application/common/web_socket/chat_socket.dart';
import 'package:chat_application/features/home/chat_list/data/models/chat_list_model.dart';
import 'package:chat_application/features/home/chat_list/notifiers/chat_list_notifier.dart';
import 'package:chat_application/features/home/chat_list/notifiers/chat_list_state_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../contacts/data/model/create_chat_model.dart';
import '../../contacts/notifier/contact_notifier.dart';

class ChatListPage extends ConsumerStatefulWidget {
  const ChatListPage({super.key});

  @override
  ConsumerState<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends ConsumerState<ChatListPage> {
  final _chatListProvider = ChatListProvider(() => ChatListNotifier());
  final _contactProvider = ContactProvider(() => ContactNotifier());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(_chatListProvider.notifier).getChatList();
      ChatSocket.listen(
          cmd: ChatSocket.newMessage,
          callback: (v) {
            if (mounted) {
              ref.read(_chatListProvider.notifier).getChatList(loading: false);
            }
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    ChatListStateModel stateModel = ref.watch(_chatListProvider);

    TextTheme textTheme = TextTheme.of(context);
    MetaDataTextTheme metaDataTextTheme =
        Theme.of(context).extension<MetaDataTextTheme>()!;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    ColorNeutral colorNeutral = Theme.of(context).extension<ColorNeutral>()!;

    bool isLoading = stateModel.isLoading;
    bool isSuccess = stateModel.isSuccess;
    bool isFailed = stateModel.isFailed;
    ChatListModel? model = stateModel.chatListModel;
    List<Data> data = model?.data ?? [];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          Center(
            child: CircularProgressIndicator(),
          ),
        if (isFailed)
          Center(
            child: Text('Failed to load chat lists'),
          ),
        if (isSuccess)
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: data.length,
              itemBuilder: (context, index) {
                Data chat = data[index];
                ChatListUser? otherUser = _getOtherUser(chat);
                return InkWell(
                  onTap: () {
                    _createChat(otherUser?.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          otherUser?.name ?? '',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          chat.latestMessage?.content ?? '',
                          style: metaDataTextTheme.metaData1.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Divider(
                          color: colorNeutral.neutralLine,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  ChatListUser? _getOtherUser(Data? data) {
    AppStorage appStorage = GetIt.I.get();
    String myId = appStorage.getUserId();
    List<ChatListUser> users = data?.users ?? [];

    if (users.isNotEmpty && users.length == 2) {
      ChatListUser otherUser = users.firstWhere((e) => e.id != myId);
      return otherUser;
    }
    return null;
  }

  void _createChat(String? id) async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      useRootNavigator: false,
    );
    try {
      ContactNotifier notifier = ref.read(_contactProvider.notifier);
      CreateChatModel chatModel = await notifier.createChat(id ?? '');
      if (mounted) {
        context.push(
          "/chat-detail",
          extra: chatModel,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Create chat error'),
          ),
        );
      }
    } finally {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
}
