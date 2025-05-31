import 'package:chat_application/common/storage/app_storage.dart';
import 'package:chat_application/di/locator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef ThemeProvider = NotifierProvider<ThemeNotifier, ThemeStateModel>;

class ThemeStateModel {
  final bool isDark;

  ThemeStateModel({required this.isDark});

  ThemeStateModel copWith({bool? isDark}) {
    return ThemeStateModel(
      isDark: isDark ?? this.isDark,
    );
  }
}

class ThemeNotifier extends Notifier<ThemeStateModel> {
  final AppStorage _appStorage = getIt.get<AppStorage>();
  @override
  ThemeStateModel build() {
    bool isDark = _appStorage.getTheme();
    return ThemeStateModel(isDark: isDark);
  }

  void changeTheme(bool isDark) {
    _appStorage.saveTheme(isDark);
    state = state.copWith(isDark: isDark);
  }
}
