import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class TipsCardGem extends StatelessWidget {
  final String tip;

  const TipsCardGem({Key? key, required this.tip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              tip,
              textStyle: Theme.of(context).textTheme.bodyMedium,
              speed: const Duration(milliseconds: 30),
              cursor: '',
            ),
          ],
          totalRepeatCount: 1, // Animation runs only once
          isRepeatingAnimation: false, // Don't repeat
          displayFullTextOnTap: true, // Show full text if tapped
        ),
      ),
    );
  }
}
