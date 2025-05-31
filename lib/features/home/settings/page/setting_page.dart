import 'package:chat_application/common/storage/app_storage.dart';
import 'package:chat_application/common/theme/theme_notfier.dart';
import 'package:chat_application/di/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  ConsumerState<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  final ThemeProvider _provider = getIt.get<ThemeProvider>();
  final AppStorage _storage = getIt.get<AppStorage>();
  @override
  Widget build(BuildContext context) {
    bool isDark = ref.watch(_provider).isDark;
    ThemeNotifier notifier = ref.read(_provider.notifier);
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.person),
          title: Text(_storage.getUserName()),
        ),
        SwitchListTile(
          title: Text("Dark Theme"),
          value: isDark,
          onChanged: (bool isDark) {
            notifier.changeTheme(isDark);
          },
        ),
        ListTile(
          onTap: () async {
            await _storage.logout();
            if (context.mounted) {
              context.go("/login");
            }
          },
          title: Text("Logout"),
          trailing: Icon(Icons.logout),
        )
      ],
    );
  }
}
