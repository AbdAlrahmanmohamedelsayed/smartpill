import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/model/data_medicine.dart';
import 'package:intl/intl.dart';

class CustomMedicineItem extends StatefulWidget {
  final MedicinePill data;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CustomMedicineItem({
    super.key,
    required this.data,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<CustomMedicineItem> createState() => _CustomMedicineItemState();
}

class _CustomMedicineItemState extends State<CustomMedicineItem> {
  // Map to track checked status for each reminder time
  late Map<TimeOfDay, bool> checkedStatus;

  @override
  void initState() {
    super.initState();
    // Initialize each reminder time as unchecked
    checkedStatus = {for (var time in widget.data.reminderTimes) time: false};
  }

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
                      widget.data.name,
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
                        onTap: widget.onEdit,
                        imagePath: 'assets/images/icons/edit-icon.png',
                        backgroundColor: AppColor.primaryColor.withOpacity(0.4),
                        size: actionButtonSize,
                      ),
                      SizedBox(width: screenWidth * 0.06),
                      _buildActionButton(
                        onTap: widget.onDelete,
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
                text: 'Dose: ${widget.data.dose} mg',
                fontSize: regularFontSize,
              ),
              SizedBox(height: spaceBetweenElements),
              _buildInfoRow(
                emoji: '💊',
                text: 'Pills Amount: ${widget.data.amount}',
                fontSize: regularFontSize,
              ),
              SizedBox(height: spaceBetweenElements * 2),
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
                children: widget.data.reminderTimes.map((time) {
                  final formattedTime = MaterialLocalizations.of(context)
                      .formatTimeOfDay(time, alwaysUse24HourFormat: false);

                  return _buildTimeChipWithCheckbox(
                    text: formattedTime,
                    fontSize: regularFontSize * 0.95,
                    time: time,
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

  // Modified time chip with a checkbox
  Widget _buildTimeChipWithCheckbox({
    required String text,
    required double fontSize,
    required TimeOfDay time,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Toggle the checked status
          checkedStatus[time] = !(checkedStatus[time] ?? false);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: checkedStatus[time] == true
              ? AppColor.accentGreen.withOpacity(0.5)
              : AppColor.primaryColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColor.primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Checkbox
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: AppColor.primaryColor,
                  width: 1.5,
                ),
              ),
              child: checkedStatus[time] == true
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: AppColor.primaryColor,
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            // Time text
            Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                decoration: checkedStatus[time] == true
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
