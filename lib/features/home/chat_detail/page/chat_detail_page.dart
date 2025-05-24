import 'package:chat_application/common/theme/extension/color_neutral.dart';
import 'package:chat_application/features/home/chat_detail/data/models/message_model.dart';
import 'package:chat_application/features/home/chat_detail/notifier/chat_detail_state_model.dart';
import 'package:chat_application/features/home/chat_detail/notifier/chat_detail_state_notifier.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/storage/app_storage.dart';
import '../../../../common/theme/extension/color_brand.dart';
import '../../contacts/data/model/create_chat_model.dart';

class ChatDetailPage extends ConsumerStatefulWidget {
  const ChatDetailPage({super.key});

  @override
  ConsumerState<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends ConsumerState<ChatDetailPage> {
  Users? _otherUser;
  CreateChatModel? _createChatModel;
  String? _myId;
  final AppStorage _appStorage = GetIt.I.get<AppStorage>();
  final TextEditingController _controller = TextEditingController();

  final ChatDetailProvider _provider = ChatDetailProvider(
    () => ChatDetailStateNotifier(),
  );
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GoRouterState state = GoRouterState.of(context);
      CreateChatModel? model = state.extra as CreateChatModel?;
      _createChatModel = model;
      _myId = _appStorage.getUserId();
      _getOtherUser(model);
      String? id = model?.data?.id;
      if (id != null) {
        ref.read(_provider.notifier).getAllMessage(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    ColorBrand colorBrand = Theme.of(context).extension<ColorBrand>()!;
    TextTheme textTheme = TextTheme.of(context);
    ColorNeutral colorNeutral = Theme.of(context).extension<ColorNeutral>()!;

    ChatDetailStateModel detailStateModel = ref.watch(_provider);
    bool isLoading = detailStateModel.isLoading;
    bool isSuccess = detailStateModel.isSuccess;
    bool isFailed = detailStateModel.isFailed;

    MessageModel messageModel = detailStateModel.messageModel;
    List<MessageData> messages = messageModel.data ?? [];

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(_otherUser?.name ?? '......'),
      ),
      body: Column(
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(),
                ),
              if (isFailed)
                Center(
                  child: Text('Failed to Load messaged'),
                ),
              if (isSuccess)
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      MessageData data = messages[index];

                      String? senderId = data.sender?.id;
                      bool isOwnMessage = senderId == _myId;

                      return BubbleSpecialThree(
                        isSender: isOwnMessage,
                        color: isOwnMessage
                            ? colorBrand.brandDefault
                            : colorScheme.surfaceContainerLow,
                        text: data.content ?? '',
                        textStyle: textTheme.bodyMedium!.copyWith(
                          color: isOwnMessage
                              ? colorNeutral.buttonText
                              : colorScheme.onSurface,
                        ),
                      );
                    },
                  ),
                ),
            ],
          )),
          _chatTextFiled(),
        ],
      ),
    );
  }

  void _getOtherUser(CreateChatModel? model) {
    List<Users> users = model?.data?.users ?? [];

    if (users.isNotEmpty && users.length == 2) {
      Users otherUser = users.firstWhere((e) => e.id != _myId);
      setState(() {
        _otherUser = otherUser;
      });
    }
  }

  Widget _chatTextFiled() {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    ColorBrand colorBrand = Theme.of(context).extension<ColorBrand>()!;
    return Row(
      children: [
        Expanded(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 16.0,
              ),
              child: TextField(
                controller: _controller,
                onChanged: (_) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  border: InputBorder.none,
                  hintText: 'Message',
                ),
              ),
            ),
          ),
        ),
        IconButton(
          color: colorBrand.brandDefault,
          onPressed: _controller.text.trim().isNotEmpty ? _sendMessage : null,
          icon: Icon(Icons.send),
        )
      ],
    );
  }

  void _sendMessage() async {
    try {
      String? id = _createChatModel?.data?.id;
      if (id != null) {
        await ref.read(_provider.notifier).sendMessage(
              chatId: id,
              content: _controller.text,
            );
        _controller.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send'),
          ),
        );
      }
    }
  }
}
