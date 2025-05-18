import 'package:chat_application/features/home/contacts/data/model/create_chat_model.dart';
import 'package:dio/dio.dart';

import '../../../../../common/const/url_cont.dart';
import '../../../../../di/locator.dart';
import '../model/contact_model.dart';

class ContactService {
  final Dio _dio = getIt.get<Dio>(instanceName: 'auth');
  Future<ContactModel> getContacts({String search = ''}) async {
    String params = search.trim().isEmpty ? '' : '=$search';
    final resp = await _dio.get('${UrlConst.user}$params');
    return ContactModel.fromJson(resp.data);
  }

  Future<CreateChatModel> createChat({required String userId}) async {
    final resp = await _dio.post(
      UrlConst.createChat,
      data: {
        "users": [userId]
      },
    );
    return CreateChatModel.fromJson(resp.data);
  }
}
