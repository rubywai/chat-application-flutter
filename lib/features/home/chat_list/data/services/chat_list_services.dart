import 'package:chat_application/common/const/url_cont.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../models/chat_list_model.dart';

class ChatListService {
  final Dio _dio = GetIt.I.get(instanceName: 'auth');
  Future<ChatListModel> getChatList() async {
    final resp = await _dio.get(UrlConst.getAllChat);
    return ChatListModel.fromJson(resp.data);
  }
}
