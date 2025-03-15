import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/model/data_medicine.dart';

// ignore: must_be_immutable
class CustomMedicineItem extends StatelessWidget {
  MedicinePill data;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  CustomMedicineItem({
    super.key,
    required this.data,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.15), // Darker shadow for better visibility
            blurRadius: 15,
            spreadRadius: 4,
            offset: const Offset(0, 6), // Deeper shadow effect
          ),
        ],
      ),
      child: Card(
        color: Colors.white,
        surfaceTintColor: AppColor.whiteColor.withOpacity(0.3),
        shadowColor:
            Colors.transparent, // Remove default shadow to rely on boxShadow
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: AppColor.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text('💊 Dose: ${data.dose} mg',
                        style: theme.textTheme.bodySmall),
                    Text('💊 Pills Amount: ${data.amount}',
                        style: theme.textTheme.bodySmall),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: data.reminderTimes.map((time) {
                        final formattedTime =
                            MaterialLocalizations.of(context).formatTimeOfDay(
                          time,
                          alwaysUse24HourFormat: false,
                        );

                        return Chip(
                          label: Text(formattedTime,
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: AppColor.textColorPrimary)),
                          backgroundColor:
                              AppColor.primaryColor.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // Buttons (Right Side)
              Column(
                children: [
                  InkWell(
                    onTap: onEdit,
                    child: Image.asset(
                      'assets/images/icons/edit-icon.png',
                      width: 60,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: onDelete,
                    child: Image.asset(
                      'assets/images/icons/delete-icon.png',
                      width: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
