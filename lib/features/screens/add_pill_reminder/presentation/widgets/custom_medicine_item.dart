import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/model/data_medicine.dart';
import 'package:intl/intl.dart';

class CustomMedicineItem extends StatelessWidget {
  final MedicinePill data;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CustomMedicineItem({
    super.key,
    required this.data,
    required this.onEdit,
    required this.onDelete,
  });

  // Fixed formatting function to handle both String and DateTime types
  String _formatDate(dynamic dateInput) {
    try {
      DateTime date;
      if (dateInput is String) {
        date = DateTime.parse(dateInput);
      } else if (dateInput is DateTime) {
        date = dateInput;
      } else {
        return dateInput.toString();
      }

      // Use English locale for formatting
      final formatter = DateFormat('dd MMM yyyy');
      return formatter.format(date);
    } catch (e) {
      return dateInput.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double cardMarginHorizontal = screenWidth * 0.04;
    final double cardMarginVertical = screenHeight * 0.01;
    final double contentPadding = screenWidth * 0.04;
    final double titleFontSize = screenWidth * 0.070;
    final double regularFontSize = screenWidth * 0.04;
    final double actionButtonSize = screenWidth * 0.08;
    final double spaceBetweenElements = screenHeight * 0.01;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: cardMarginVertical,
        horizontal: cardMarginHorizontal,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.textColorPrimary.withOpacity(0.25),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: EdgeInsets.all(contentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      data.name,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Row(
                    children: [
                      _buildActionButton(
                        onTap: onEdit,
                        imagePath: 'assets/images/icons/edit-icon.png',
                        backgroundColor: AppColor.primaryColor.withOpacity(0.4),
                        size: actionButtonSize,
                      ),
                      SizedBox(width: screenWidth * 0.06),
                      _buildActionButton(
                        onTap: onDelete,
                        imagePath: 'assets/images/icons/delete-icon.png',
                        backgroundColor: Colors.red.withOpacity(0.1),
                        size: actionButtonSize,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: spaceBetweenElements * 2),
              _buildInfoRow(
                emoji: '💊',
                text: 'Dose: ${data.dose} mg',
                fontSize: regularFontSize,
              ),
              SizedBox(height: spaceBetweenElements),
              _buildInfoRow(
                emoji: '💊',
                text: 'Pills Amount: ${data.amount}',
                fontSize: regularFontSize,
              ),
              SizedBox(height: spaceBetweenElements * 2),
              // Updated date displays with English labels

              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: spaceBetweenElements * 2),
                child: Divider(
                  color: AppColor.primaryColor.withOpacity(0.2),
                  thickness: 1,
                ),
              ),
              Text(
                'Reminder Times',
                style: TextStyle(
                  fontSize: regularFontSize * 1.1,
                  fontWeight: FontWeight.w600,
                  color: AppColor.primaryColor,
                ),
              ),
              SizedBox(height: spaceBetweenElements * 1.5),
              Wrap(
                spacing: screenWidth * 0.025,
                runSpacing: screenHeight * 0.008,
                children: data.reminderTimes.map((time) {
                  final formattedTime = MaterialLocalizations.of(context)
                      .formatTimeOfDay(time, alwaysUse24HourFormat: false);

                  return _buildTimeChip(
                    text: formattedTime,
                    fontSize: regularFontSize * 0.95,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Improved date row with English text directionality
  Widget _buildDateRow({
    required String emoji,
    required String label,
    required String date,
    required double fontSize,
    required Color color,
  }) {
    return Row(
      children: [
        Text(
          emoji,
          style: TextStyle(fontSize: fontSize * 1.2),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            date,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required String emoji,
    required String text,
    required double fontSize,
  }) {
    return Row(
      children: [
        Text(
          emoji,
          style: TextStyle(fontSize: fontSize * 1.2),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required String imagePath,
    required Color backgroundColor,
    required double size,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(size * 0.2),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(
          imagePath,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildTimeChip({
    required String text,
    required double fontSize,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppColor.primaryColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
