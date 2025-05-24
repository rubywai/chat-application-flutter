import 'package:chat_application/features/home/chat_detail/data/models/message_model.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../../../common/const/url_cont.dart';
import '../models/send_message_model.dart';

class ChatDetailService {
  final Dio _dio = GetIt.I.get(instanceName: 'auth');
  Future<SendMessageModel> sendMessage({
    required chatId,
    required content,
  }) async {
    final resp = await _dio.post(
      UrlConst.sendMessage,
      data: {
        'content': content,
        'chat_id': chatId,
      },
    );
    return SendMessageModel.fromJson(resp.data);
  }

  Future<MessageModel> getAllMessage({
    required String chatId,
  }) async {
    final resp = await _dio.get(
      '${UrlConst.getAllMessage}?chat_id=$chatId',
    );
    return MessageModel.fromJson(resp.data);
  }
}
