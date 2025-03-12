import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/features/screens/menu/drug_interaction/Service/api_service.dart';
import 'package:smartpill/features/screens/menu/drug_interaction/widgets/buildDrugInputField.dart';
import 'package:smartpill/features/screens/widgets/card_interAction.dart';
import 'package:smartpill/model/drug_interaction.dart';

class DrugInteractionView extends StatefulWidget {
  const DrugInteractionView({super.key});

  @override
  State<DrugInteractionView> createState() => _DrugInteractionViewState();
}

class _DrugInteractionViewState extends State<DrugInteractionView> {
  final TextEditingController drug1Controller = TextEditingController();
  final TextEditingController drug2Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<DrugInteraction?>? _interactionResult;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
        ),
        backgroundColor: AppColor.primaryColor,
        toolbarHeight: 80,
        titleTextStyle: theme.appBarTheme.titleTextStyle
            ?.copyWith(color: AppColor.whiteColor),
        title: const Text('Drug Interaction'),
        leading: const BackButton(
          color: AppColor.whiteColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Enter Medication 1',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                BuildDrugInputField(
                  onSearch: (query) =>
                      ApiServiceDruginteraction().searchDrugNames(query),
                  controller: drug1Controller,
                  hintText: 'Enter the first medicine',
                ),
                const SizedBox(height: 20),
                Text(
                  'Enter Medication 2',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                BuildDrugInputField(
                  onSearch: (query) =>
                      ApiServiceDruginteraction().searchDrugNames(query),
                  controller: drug2Controller,
                  hintText: 'Enter the second medicine',
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: AppColor.accentGreen,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _interactionResult =
                            ApiServiceDruginteraction().fetchDrugInteraction(
                          drug1Controller.text.trim(),
                          drug2Controller.text.trim(),
                        );
                      });
                    }
                  },
                  child: Text(
                    'Check Interaction',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColor.textColorPrimary),
                  ),
                ),
                const SizedBox(height: 20),
                _buildResultWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultWidget() {
    if (_interactionResult == null) {
      return const SizedBox();
    }

    return FutureBuilder<DrugInteraction?>(
      future: _interactionResult,
      builder:
          (BuildContext context, AsyncSnapshot<DrugInteraction?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.primaryColor),
          );
        } else if (!snapshot.hasData) {
          return const Center(
            child: Text(
              'No interaction found.',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColor.accentGreen),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else {
          final interaction = snapshot.data!;
          return CardInteractionView(
            interactiondat: interaction,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    drug1Controller.dispose();
    drug2Controller.dispose();
    super.dispose();
  }
}
