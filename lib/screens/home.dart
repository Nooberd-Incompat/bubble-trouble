import 'dart:async';
import 'package:bubbletrouble/widgets/ball.dart';
import 'package:bubbletrouble/widgets/button.dart';
import 'package:bubbletrouble/widgets/missile.dart';
import 'package:bubbletrouble/widgets/player.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum direction { LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  //player variables
  static double playerX = 0;
  //missile variables
  double missileX = playerX;
  double missileheight = 10;
  bool midShot = false;
  //ball varaibles
  double ballX = 0.5;
  double ballY = 0;
  var ballDirection = direction.LEFT;

  void startGame() {
    double time = 0;
    double height = 0;
    double velocity = 200; //how strong the jump of the ball is
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;

    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      //quadratic equation that models a bounce (upside down parabola)
      height = -5 * time * time + velocity * time;

      // if ball reaches ground, reset the jump
      if (height < 0) {
        time = 0;
      }

      // if ball reaches top of the screen, bounce
      if (height == totalHeight) {
        velocity = -velocity;
      }
      setState(() {
        ballY = heightToPosition(height);
      });
      if (ballX - 0.02 < -1) {
        ballDirection = direction.RIGHT;
      } else if (ballX + 0.02 > 1) {
        ballDirection = direction.LEFT;
      }
      if (ballDirection == direction.LEFT) {
        setState(() {
          ballX -= 0.02;
        });
      } else if (ballDirection == direction.RIGHT) {
        setState(() {
          ballX += 0.02;
        });
      }

// check if the ball hits the player
      if (playerDies()) {
        timer.cancel();
        print("dead");
      }
//keep the time going
      time += 0.02;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("You are no longer skibidi",
                style: TextStyle(color: Colors.white)),
          );
        });
  }

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
        //stop missile when on top of the screen
        if (missileheight > MediaQuery.of(context).size.height * 3 / 4) {
          resetMissile();
          timer.cancel();
        }
        //check if missile has hit the ball
        if (ballY > heightToPosition(missileheight) &&
            (ballX - missileX).abs() < 0.03) {
          resetMissile();
          ballX = 5;
          timer.cancel();
        }
      });
    }
  }

//converts height to coordinate
  double heightToPosition(double height) {
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;
    double position = 1 - 2 * height / totalHeight;
    return position;
  }

  void resetMissile() {
    missileX = playerX;
    missileheight = 10;
    midShot = false;
  }

  bool playerDies() {
// if ball touches player
//are same, player dies
    if ((ballX - playerX).abs() < 0.05 && ballY > 0.95) {
      return true;
    } else
      return false;
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
                  MyBall(ballX: ballX, ballY: ballY),
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
                  icon: Icons.play_arrow,
                  function: startGame,
                ),
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
