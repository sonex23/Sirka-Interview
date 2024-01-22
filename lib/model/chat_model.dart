import 'package:hive_flutter/hive_flutter.dart';

part 'chat_model.g.dart';

@HiveType(typeId: 1, adapterName: 'ChatModelAdapter')
class ChatModel {
  @HiveField(1)
  int? id;
  @HiveField(2)
  String? contact;
  @HiveField(3)
  List<Chat>? chat;
  @HiveField(4)
  String? profile;

  ChatModel({
    this.id,
    this.contact,
    this.chat,
    this.profile,
  });

  ChatModel copyWith({
    int? id,
    String? contact,
    List<Chat>? chat,
    String? profile,
  }) =>
      ChatModel(
        id: id ?? this.id,
        contact: contact ?? this.contact,
        chat: chat ?? this.chat,
        profile: profile ?? this.profile,
      );
}

@HiveType(typeId: 2, adapterName: 'ChatAdapter')
class Chat {
  @HiveField(1)
  String? text;
  @HiveField(2)
  bool? fromContact;
  @HiveField(3)
  String? time;

  Chat({
    this.text,
    this.fromContact,
    this.time,
  });
}
