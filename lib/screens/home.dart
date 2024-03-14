import 'package:bubbletrouble/widgets/button.dart';
import 'package:bubbletrouble/widgets/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //player variables
  double playerX = 0;

  void moveLeft() {
    setState(() {
      playerX -= 0.1;
    });
  }

  void moveRight() {
    setState(() {
      playerX += 0.1;
    });
  }

  void fireMissile() {}

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      // onKeyEvent: (KeyEvent event) {if(event.physicalKey.)},
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.pink[100],
              child: Center(
                child: Stack(
                  children: [
                    MyPlayer(playerX: playerX),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
                color: Colors.grey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyButton(
                      icon: Icons.arrow_back,
                      function: moveLeft,
                    ),
                    MyButton(
                      icon: Icons.arrow_upward,
                      function: fireMissile,
                    ),
                    MyButton(
                      icon: Icons.arrow_forward,
                      function: moveRight,
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
