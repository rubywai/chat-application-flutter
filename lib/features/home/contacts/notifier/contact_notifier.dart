import 'package:chat_application/features/home/contacts/data/model/create_chat_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/model/contact_model.dart';
import '../data/services/contact_service.dart';
import 'contact_state_model.dart';

typedef ContactProvider = NotifierProvider<ContactNotifier, ContactStateModel>;

class ContactNotifier extends Notifier<ContactStateModel> {
  final ContactService _contactService = ContactService();
  @override
  ContactStateModel build() {
    return ContactStateModel(
      isLoading: true,
      isSuccess: false,
      isFailed: false,
      contactModel: null,
    );
  }

  void getContacts({String search = ''}) async {
    try {
      state = state.copyWith(
        isLoading: true,
        isSuccess: false,
        isFailed: false,
      );

      ContactModel contactModel = await _contactService.getContacts(
        search: search,
      );
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        contactModel: contactModel,
      );
    } catch (e) {
      if (e is DioException && e.response?.data['message'] != null) {
        state = state.copyWith(
            isLoading: false,
            isFailed: true,
            errorMessage: e.response?.data['message']);
      } else {
        state = state.copyWith(
          isLoading: false,
          isFailed: true,
          errorMessage: 'Something wrong',
        );
      }
    }
  }

  Future<CreateChatModel> createChat(String userId) async {
    try {
      CreateChatModel createChatModel =
          await _contactService.createChat(userId: userId);
      return createChatModel;
    } catch (e) {
      return Future.error(e);
    }
  }
}
