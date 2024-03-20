import 'package:flutter/material.dart';

class MyMissile extends StatelessWidget {
  const MyMissile({super.key, this.missileX, this.missileheight});

  final missileX;
  final missileheight;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(missileX, 1),
      child: Container(
        width: 8,
        height: missileheight,
        color: Colors.grey,
      ),
    );
  }
}
