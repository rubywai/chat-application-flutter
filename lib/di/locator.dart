import 'package:chat_application/common/routes/routes.dart';
import 'package:chat_application/common/theme/theme_notfier.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/const/url_cont.dart';
import '../common/storage/app_storage.dart';

final getIt = GetIt.I;
Future<void> setupLocator() async {
  Dio dio = Dio();
  dio.options.baseUrl = UrlConst.baseUrl;
  dio.interceptors.add(PrettyDioLogger());
  getIt.registerSingleton<Dio>(dio);

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  getIt.registerSingleton(AppStorage());

  Dio authDio = Dio();
  authDio.options.baseUrl = UrlConst.baseUrl;
  authDio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
    ),
  );
  authDio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, interceptor) async {
        AppStorage storage = getIt.get<AppStorage>();
        if (storage.getToken().isEmpty) {
          await storage.logout();
          router.goNamed("login");
        }
        options.headers['Authorization'] = 'Bearer ${storage.getToken()}';

        interceptor.next(options);
      },
    ),
  );
  getIt.registerSingleton(authDio, instanceName: 'auth');

  ThemeProvider themeProvider = ThemeProvider(() {
    return ThemeNotifier();
  });
  getIt.registerSingleton(themeProvider);
}
