import 'package:flutter/material.dart';
import 'motel_card.dart';

class MotelCardList extends StatelessWidget {
  const MotelCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: const [
        MotelCard(),
        MotelCard(),
        MotelCard(),
      ],
    );
  }
}
