import 'dart:async';
import 'package:bubbletrouble/widgets/button.dart';
import 'package:bubbletrouble/widgets/missile.dart';
import 'package:bubbletrouble/widgets/player.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //player variables
  static double playerX = 0;
  //missile variables
  double missileX = playerX;
  double missileheight = 10;
  bool midShot = false;

  void moveLeft() {
    setState(() {
      if (playerX - 0.1 < -1) {
      } else {
        playerX -= 0.1;
      }
      //only make the X coordinate same, if the shot has not yet commenced
      if (!midShot) {
        missileX = playerX;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (playerX + 0.1 > 1) {
        //do nothing
      } else {
        playerX += 0.1;
      }
      //only make the X coordinate same, if the shot has not yet commenced
      if (!midShot) {
        missileX = playerX;
      }
    });
  }

  void fireMissile() {
    if (!midShot) {
      Timer.periodic(Duration(milliseconds: 20), (timer) {
        //shots fired
        midShot = true;

//missile grows till it hits the top of the screen
        setState(() {
          missileheight += 10;
        });
        if (missileheight > MediaQuery.of(context).size.height * 3 / 4) {
          //stop missile
          resetMissile();
          timer.cancel();
          midShot = false;
        }
      });
    }
  }

  void resetMissile() {
    missileX = playerX;
    missileheight = 10;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.pink[100],
            child: Center(
              child: Stack(
                children: [
                  MyMissile(
                    missileX: missileX,
                    missileheight: missileheight,
                  ),
                  MyPlayer(
                    playerX: playerX,
                  ),
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
            ),
          ),
        )
      ],
    );
  }
}
