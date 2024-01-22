import 'package:hive_flutter/hive_flutter.dart';
import 'package:sirka_interview/model/chat_model.dart';
import 'package:sirka_interview/services/hive_client_contract.dart';

class HiveClient extends HiveClientContract {
  @override
  Future<void> setupHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ChatModelAdapter());
    Hive.registerAdapter(ChatAdapter());
    await Hive.openBox('history');
    var box = await Hive.openBox('chat');

    if (!box.containsKey('chat_list')) {
      box.put(
        'chat_list',
        <ChatModel>[
          ChatModel(
            id: 1,
            contact: "Dr. Rahmad Dani",
            profile: 'assets/profile1.png',
            chat: [
              Chat(
                text: 'Halo dokter Dani',
                time: DateTime.now().toString(),
                fromContact: false,
              ),
              Chat(
                text: 'Halo kids, this is your doctor',
                time: DateTime.now().toString(),
                fromContact: true,
              ),
            ],
          ),
          ChatModel(
            id: 2,
            contact: "Dr. Nadira Yasmin",
            profile: 'assets/profile2.png',
            chat: [
              Chat(
                text: 'Halo dokter Nadira',
                time: DateTime.now().toString(),
                fromContact: false,
              ),
            ],
          ),
          ChatModel(
            id: 3,
            contact: "Dr. Sona Ermando",
            profile: 'assets/profile3.png',
            chat: [
              Chat(
                text: 'Halo dokter Sona',
                time: DateTime.now().toString(),
                fromContact: false,
              ),
            ],
          ),
        ],
      );
    }
  }

  @override
  Future getByKeyAndBox({required String key, required String box}) async {
    var hiveBox = Hive.box(box);
    return hiveBox.get(key);
  }

  @override
  Future saveByKeyAndBox({required String key, required String box, required Object value}) async {
    var hiveBox = Hive.box(box);
    await hiveBox.put(key, value);
  }

  @override
  Future deleteAllValueByBox({required String box}) async {
    var hiveBox = Hive.box(box);
    await hiveBox.deleteAll(hiveBox.keys);
  }

  @override
  Future deleteValueByKey({required String key, required String box}) async {
    var hiveBox = Hive.box(box);
    await hiveBox.delete(key);
  }
}
