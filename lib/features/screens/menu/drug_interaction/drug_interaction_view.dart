import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/features/screens/menu/drug_interaction/Service/api_service.dart';
import 'package:smartpill/features/screens/widgets/card_interAction.dart';
import 'package:smartpill/model/drug_interaction.dart';

class DrugInteractionView extends StatefulWidget {
  const DrugInteractionView({super.key});

  @override
  State<DrugInteractionView> createState() => _DrugInteractionViewState();
}

class _DrugInteractionViewState extends State<DrugInteractionView> {
  TextEditingController drug1Controller = TextEditingController();
  TextEditingController drug2Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<DrugInteraction?>? _interactionResult; // Future لتخزين نتيجة التفاعل

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(20))),
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
                _buildDrugInputField(
                    controller: drug1Controller,
                    hintText: 'Enter the first medicine'),
                const SizedBox(height: 20),
                Text(
                  'Enter Medication 2',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                _buildDrugInputField(
                    controller: drug2Controller,
                    hintText: 'Enter the second medicine'),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: AppColor.accentGreen,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _interactionResult = ApiService().fetchDrugInteraction(
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
                _buildResultWidget(), // عرض النتيجة
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildDrugInputField(
      {required TextEditingController controller, required String hintText}) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a drug name';
        }
        return null;
      },
      style: Theme.of(context).textTheme.bodySmall,
      controller: controller,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16),
        suffixIcon: const Icon(
          Icons.search,
          color: AppColor.primaryColor,
          size: 22,
        ),
        hintText: hintText,
        hintStyle: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: AppColor.textColorHint),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.primaryColor),
        ),
      ),
    );
  }

  _buildResultWidget() {
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
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text(
              'No interaction found.',
              style: TextStyle(fontSize: 16),
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
}
