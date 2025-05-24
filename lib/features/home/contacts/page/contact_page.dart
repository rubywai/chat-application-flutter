import 'package:chat_application/common/theme/extension/color_neutral.dart';
import 'package:chat_application/common/theme/extension/meta_data_text_theme.dart';
import 'package:chat_application/features/home/contacts/data/model/contact_model.dart';
import 'package:chat_application/features/home/contacts/data/model/create_chat_model.dart';
import 'package:chat_application/features/home/contacts/notifier/contact_state_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../notifier/contact_notifier.dart';

class ContactPage extends ConsumerStatefulWidget {
  const ContactPage({super.key});

  @override
  ConsumerState<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends ConsumerState<ContactPage> {
  final ContactProvider _provider = ContactProvider(() => ContactNotifier());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(_provider.notifier).getContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = TextTheme.of(context);
    ColorScheme scheme = Theme.of(context).colorScheme;
    MetaDataTextTheme metaDataTextTheme =
        Theme.of(context).extension<MetaDataTextTheme>()!;
    ColorNeutral colorNeutral = Theme.of(context).extension<ColorNeutral>()!;

    ContactStateModel stateModel = ref.watch(_provider);
    ContactNotifier notifier = ref.read(_provider.notifier);

    bool isLoading = stateModel.isLoading;
    bool isSuccess = stateModel.isSuccess;
    bool isFailed = stateModel.isFailed;

    ContactModel? contactModel = stateModel.contactModel;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            style: textTheme.bodyLarge?.copyWith(
              color: scheme.onSurface,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: scheme.surfaceContainerHighest,
              border: InputBorder.none,
              hintText: 'Search',
            ),
            onChanged: (String name) {
              if (name.trim().isEmpty) {
                notifier.getContacts();
              } else {
                notifier.getContacts(search: name);
              }
            },
          ),
        ),
        if (isLoading)
          Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        if (isFailed)
          Expanded(
            child: Column(
              children: [
                Text(stateModel.errorMessage),
                SizedBox(
                  height: 4,
                ),
                OutlinedButton(
                  onPressed: () {
                    notifier.getContacts();
                  },
                  child: Text('Try Again'),
                )
              ],
            ),
          ),
        if (isSuccess)
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: contactModel?.data?.length ?? 0,
              itemBuilder: (context, index) {
                Data? contact = contactModel?.data?[index];
                return InkWell(
                  onTap: () async {
                    _createChat(contact);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact?.name ?? '',
                        style: textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurface,
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        contact?.email ?? '',
                        style: metaDataTextTheme.metaData1.copyWith(
                          color: scheme.onSurfaceVariant,
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
                );
              },
            ),
          )
      ],
    );
  }

  void _createChat(Data? contact) async {
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
      ContactNotifier notifier = ref.read(_provider.notifier);
      CreateChatModel chatModel = await notifier.createChat(contact?.id ?? '');
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
