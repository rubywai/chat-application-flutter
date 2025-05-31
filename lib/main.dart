import 'package:chat_application/common/theme/theme_notfier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/routes/routes.dart';
import 'common/theme/theme_const.dart';
import 'di/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);
  await setupLocator();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});
  final ThemeProvider _provider = getIt.get<ThemeProvider>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeStateModel model = ref.watch(_provider);
    bool isDark = model.isDark;
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeConst.lightTheme(),
      darkTheme: ThemeConst.darkTheme(),
      title: 'Flutter Demo',
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
    );
  }
}
