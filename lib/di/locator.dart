import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../common/const/url_cont.dart';

final getIt = GetIt.I;
Future<void> setupLocator() async {
  Dio dio = Dio();
  dio.options.baseUrl = UrlConst.baseUrl;
  dio.interceptors.add(PrettyDioLogger());
  getIt.registerSingleton<Dio>(dio);
}
