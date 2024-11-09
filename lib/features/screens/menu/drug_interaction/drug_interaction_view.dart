import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';

class DrugInteractionView extends StatefulWidget {
  const DrugInteractionView({super.key});

  @override
  State<DrugInteractionView> createState() => _DrugInteractionViewState();
}

class _DrugInteractionViewState extends State<DrugInteractionView> {
  TextEditingController fristDrugController = TextEditingController();
  TextEditingController secondDrugController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var meia = MediaQuery.of(context);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter Medication 1',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                  controller: fristDrugController,
                  cursorColor: theme.primaryColor,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16),
                    suffixIcon: const Icon(
                      Icons.search,
                      color: AppColor.primaryColor,
                      size: 22,
                    ),
                    hintText: 'Enter the name of the first medicine',
                    hintStyle: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColor.textColorHint),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: AppColor.primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: AppColor.primaryColor),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: AppColor.primaryColor),
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Enter Medication 2',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                  controller: secondDrugController,
                  cursorColor: theme.primaryColor,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16),
                    suffixIcon: const Icon(
                      Icons.search,
                      color: AppColor.primaryColor,
                      size: 22,
                    ),
                    hintText: 'Enter the name of the second medicine',
                    hintStyle: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColor.textColorHint),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: AppColor.primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: AppColor.primaryColor),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: AppColor.primaryColor),
                    ),
                  )),
              const SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: AppColor.accentGreen),
                  onPressed: () {},
                  child: Text(
                    'Check Interaction',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColor.textColorPrimary),
                  )),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                height: meia.size.height * 0.25,
                width: meia.size.width * 0.95,
                decoration: BoxDecoration(
                  color: AppColor.accentGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                        'There is no interaction  between the  two medications.',
                        maxLines: 2,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: AppColor.whiteColor)),
                    Text(
                      'You can safely take these medications together. Ensure to follow the prescribed dosage.',
                      style: theme.textTheme.bodySmall,
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                                width: 1, color: AppColor.borderColor))),
                    onPressed: () {},
                    child: Text(
                      'Recheck',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.accentGold,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                            width: 1, color: AppColor.borderColor),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Show More',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
