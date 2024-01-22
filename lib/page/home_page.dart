import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sirka_interview/page/bmi_page.dart';
import 'package:sirka_interview/page/chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int indexPage = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (value) {
                setState(() {
                  indexPage = value;
                });
              },
              children: [
                const BmiPage(),
                const ChatPage(),
                const Center(
                  child: Text(
                    'Setting',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 50,
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _buildNavIcon(index: 0, icon: Icons.home),
              _buildNavIcon(index: 1, icon: Icons.chat),
              _buildNavIcon(index: 2, icon: Icons.settings),
              _buildNavIcon(index: 3, icon: Icons.man),
            ]),
          )
        ],
      ),
    );
  }

  GestureDetector _buildNavIcon({
    required int index,
    required IconData icon,
  }) {
    return GestureDetector(
        onTap: () {
          pageController.animateToPage(index, duration: const Duration(milliseconds: 400), curve: Curves.ease);
        },
        child: Icon(
          icon,
          color: indexPage == index ? Colors.white : Colors.black,
        ));
  }
}
