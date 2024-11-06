import 'package:flutter/material.dart';

class DrugInteractionView extends StatelessWidget {
  const DrugInteractionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drug Interaction'),
        leading: const BackButton(),
      ),
    );
  }
}
