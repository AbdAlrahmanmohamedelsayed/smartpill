import 'package:flutter/material.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Text(
        'Sign UP.............',
        style: theme.textTheme.bodyLarge?.copyWith(color: Colors.red),
      ),
    );
  }
}
