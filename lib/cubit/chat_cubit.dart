import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sirka_interview/model/chat_model.dart';
import 'package:sirka_interview/services/hive_client_contract.dart';

part 'chat_cubit_state.dart';
part 'chat_cubit.freezed.dart';

class ChatCubit extends Cubit<ChatCubitState> {
  HiveClientContract hiveClient;
  ChatCubit(this.hiveClient) : super(const ChatCubitState.loading());

  void getChat() async {
    emit(ChatCubitState.loading());
    try {
      List chatData = await hiveClient.getByKeyAndBox(key: 'chat_list', box: 'chat');
      emit(ChatCubitState.loaded(chatData));
    } catch (e) {
      emit(ChatCubitState.error(e.toString()));
    }
  }

  void deleteChat(
    int id,
    List before,
    ChatModel chat,
    int index,
  ) async {
    emit(const ChatCubitState.loading());
    try {
      List tampung = [];
      List<Chat> tampungChat = [];
      tampung.addAll(before);
      tampungChat.addAll(tampung.firstWhere((element) => element.id == id).chat!);
      tampungChat.removeAt(index);
      ChatModel newChat = tampung.firstWhere((element) => element.id == id).copyWith(chat: tampungChat);
      tampung.removeWhere((element) => element.id == id);
      tampung.insert(0, newChat);
      await hiveClient.saveByKeyAndBox(key: 'chat_list', box: 'chat', value: tampung);
      emit(ChatCubitState.loaded(tampung));
    } catch (e) {
      emit(ChatCubitState.error(e.toString()));
    }
  }

  void sendChat(int id, List before, ChatModel sent) async {
    emit(const ChatCubitState.loading());
    try {
      List tampung = [];
      tampung.addAll(before);
      tampung.removeWhere((element) => element.id == id);
      tampung.insert(0, sent);
      tampung.reversed;
      await hiveClient.saveByKeyAndBox(key: 'chat_list', box: 'chat', value: tampung);
      emit(ChatCubitState.loaded(tampung));
    } catch (e) {
      emit(ChatCubitState.error(e.toString()));
    }
  }
}
