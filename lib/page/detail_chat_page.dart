import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sirka_interview/cubit/chat_cubit.dart';
import 'package:sirka_interview/model/chat_model.dart';
import 'package:intl/intl.dart';

class DetailChatPage extends StatefulWidget {
  final ChatModel chatModel;
  final int id;
  const DetailChatPage({
    super.key,
    required this.id,
    required this.chatModel,
  });

  @override
  State<DetailChatPage> createState() => _DetailChatPageState();
}

class _DetailChatPageState extends State<DetailChatPage> {
  TextEditingController chatController = TextEditingController();
  ScrollController scrollController = ScrollController();
  late ChatModel chatData;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(
        scrollController.position.maxScrollExtent,
      );
    });
  }

  Future<dynamic> showAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String cancelActionText,
    required String defaultActionText,
  }) async {
    // todo : showDialog for ios
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(cancelActionText),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CupertinoDialogAction(
            child: Text(defaultActionText),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 24,
              ),
              margin: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  GestureDetector(
                    child: const Icon(Icons.arrow_back_ios),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    child: Image.asset(widget.chatModel.profile ?? ''),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(widget.chatModel.contact ?? ''),
                ],
              ),
            ),
            BlocBuilder<ChatCubit, ChatCubitState>(
              builder: (context, state) {
                if (state.isLoaded) {
                  chatData = state.listChat?.firstWhere((chat) => chat.id == widget.id) as ChatModel;
                  return Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: chatData.chat?.length ?? 0,
                      separatorBuilder: (context, index) => SizedBox(
                        height: index == (chatData.chat?.length ?? 0) - 1 ? 100 : 10,
                      ),
                      itemBuilder: (context, index) {
                        if (chatData.chat?[index].fromContact == false) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onLongPress: () async {
                                  bool isDeleteChat = await showAlertDialog(
                                    context: context,
                                    title: 'Hapus Chat',
                                    content: "Apakah kamu yakin ingin menghapus chat ini?",
                                    cancelActionText: "Tidak",
                                    defaultActionText: "Iya",
                                  );

                                  if (isDeleteChat) {
                                    context.read<ChatCubit>().deleteChat(widget.id, state.listChat!, chatData, index);
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  constraints: const BoxConstraints(maxWidth: double.infinity / 2),
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 2, 69, 192),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          chatData.chat?[index].text ?? '',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          DateFormat.Hm().format(DateTime.parse(chatData.chat![index].time!)).toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onLongPress: () async {
                                  bool isDeleteChat = await showAlertDialog(
                                    context: context,
                                    title: 'Hapus Chat',
                                    content: "Apakah kamu yakin ingin menghapus chat ini?",
                                    cancelActionText: "Tidak",
                                    defaultActionText: "Iya",
                                  );

                                  if (isDeleteChat) {
                                    context.read<ChatCubit>().deleteChat(widget.id, state.listChat!, chatData, index);
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  constraints: const BoxConstraints(maxWidth: double.infinity / 2),
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                      bottomLeft: Radius.circular(0),
                                      bottomRight: Radius.circular(8),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          chatData.chat?[index].text ?? '',
                                        ),
                                        Text(
                                          DateFormat.Hm().format(DateTime.parse(chatData.chat![index].time!)).toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            BlocConsumer<ChatCubit, ChatCubitState>(
              listener: (context, state) {
                if (state.isLoaded) {
                  chatController.text = '';
                }
              },
              builder: (context, state) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: chatController,
                          maxLines: 3,
                          minLines: 1,
                          decoration: const InputDecoration(
                            filled: true,
                            border: InputBorder.none,
                            fillColor: Color.fromARGB(255, 235, 235, 235),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          List<Chat> newChat = [];
                          newChat.addAll(chatData.chat!);
                          newChat.add(
                            Chat(
                              text: chatController.text,
                              time: DateTime.now().toString(),
                              fromContact: false,
                            ),
                          );
                          context.read<ChatCubit>().sendChat(widget.id, state.listChat!, chatData.copyWith(chat: newChat));
                          newChat.add(
                            Chat(
                              text: "You are doing great Kids!",
                              time: DateTime.now().toString(),
                              fromContact: true,
                            ),
                          );
                          context.read<ChatCubit>().sendChat(widget.id, state.listChat!, chatData.copyWith(chat: newChat));

                          await Future.delayed(const Duration(milliseconds: 500));
                          scrollController.animateTo(scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 100), curve: Curves.ease);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: const Icon(
                            Icons.send,
                            color: Color.fromARGB(255, 2, 69, 192),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
