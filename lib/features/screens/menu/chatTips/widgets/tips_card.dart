import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/model/SymptomTips.dart';

class TipCard extends StatelessWidget {
  final SymptomTip symptomTip;

  const TipCard({Key? key, required this.symptomTip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: AppColor.primaryColor,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Symptom: ${symptomTip.symptom}',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: AppColor.primaryColor)),
            const SizedBox(height: 12),
            Text('Tips:', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            ...symptomTip.tips.map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: AppColor.accentGreen,
                        size: 30,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DefaultTextStyle(
                          style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ) ??
                              const TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TyperAnimatedText(
                                tip,
                                speed: const Duration(milliseconds: 100),
                              ),
                            ],
                            isRepeatingAnimation: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
