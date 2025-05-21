import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/model/data_medicine.dart';

class MedicationReminderDialog extends StatefulWidget {
  final TimeOfDay time;
  final MedicinePill data;
  final VoidCallback stopAlarmSound;
  final Future<void> Function(String) sendRequest;
  final VoidCallback scheduleAlarms;
  final Map<TimeOfDay, bool> checkedStatus;
  final String? resMassage;

  const MedicationReminderDialog({
    Key? key,
    required this.time,
    required this.data,
    required this.stopAlarmSound,
    required this.sendRequest,
    required this.scheduleAlarms,
    required this.checkedStatus,
    this.resMassage,
  }) : super(key: key);

  @override
  _MedicationReminderDialogState createState() =>
      _MedicationReminderDialogState();
}

class _MedicationReminderDialogState extends State<MedicationReminderDialog>
    with TickerProviderStateMixin {
  late AnimationController _imagePulseController;

  @override
  void initState() {
    super.initState();
    _imagePulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _imagePulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog.fullscreen(
      child: Container(
        color: AppColor.whiteColor,
        child: SafeArea(
          child: Stack(
            children: [
              // Main content
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: screenHeight * 0.04,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Header
                    Column(
                      children: [
                        Text(
                          'Medication Reminder',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.05,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                blurRadius: 8,
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        // Close button
                        Align(
                          alignment: Alignment.topRight,
                          child: Semantics(
                            label: 'Close medication reminder',
                            child: IconButton(
                              icon: const Icon(Icons.close,
                                  color: AppColor.primaryColor, size: 28),
                              onPressed: () {
                                widget.stopAlarmSound();
                                Navigator.of(context).pop();
                              },
                              tooltip: 'Dismiss Alarm',
                              splashRadius: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Image
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: ScaleTransition(
                          scale: Tween(begin: 1.0, end: 1.1).animate(
                            CurvedAnimation(
                              parent: _imagePulseController,
                              curve: Curves.easeInOut,
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/icons/medicine_icon.png',
                            width: screenWidth * 0.5,
                            height: screenWidth * 0.5,
                            fit: BoxFit.contain,
                            semanticLabel: 'Medication Reminder Icon',
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.medication,
                              color: AppColor.primaryColor,
                              size: screenWidth * 0.25,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    // Medication details in a grid
                    Expanded(
                      flex: 3,
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.6,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildDetailCard(
                            label: '💊 Medication',
                            value: widget.data.name,
                            fontSize: screenWidth * 0.04,
                          ),
                          _buildDetailCard(
                            label: '💊 Dose',
                            value: '${widget.data.dose} mg',
                            fontSize: screenWidth * 0.04,
                          ),
                          _buildDetailCard(
                            label: 'Time',
                            value: MaterialLocalizations.of(context)
                                .formatTimeOfDay(widget.time),
                            fontSize: screenWidth * 0.04,
                          ),
                          _buildDetailCard(
                            label: 'Pills',
                            value: '${widget.data.amount}',
                            fontSize: screenWidth * 0.04,
                          ),
                        ],
                      ),
                    ),
                    // Action buttons
                    Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildAnimatedButton(
                            icon: Icons.check_circle,
                            label: 'Taken',
                            color: Colors.amber[600]!,
                            onPressed: () async {
                              setState(() {
                                widget.checkedStatus[widget.time] = true;
                              });
                              widget.stopAlarmSound();
                              await widget
                                  .sendRequest('http://192.168.4.1/Alarm');
                              Navigator.of(context).pop();
                              if (widget.resMassage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'API Response: ${widget.resMassage}'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                              widget.scheduleAlarms();
                            },
                          ),
                          _buildAnimatedButton(
                            icon: Icons.snooze,
                            label: 'Snooze',
                            color: AppColor.primaryColor,
                            onPressed: () {
                              final now = DateTime.now();
                              final laterTime = TimeOfDay(
                                hour:
                                    (now.hour + ((now.minute + 15) ~/ 60)) % 24,
                                minute: (now.minute + 15) % 60,
                              );
                              setState(() {
                                widget.data.reminderTimes.add(laterTime);
                                widget.checkedStatus[laterTime] = false;
                              });
                              widget.stopAlarmSound();
                              Navigator.of(context).pop();
                              widget.scheduleAlarms();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.42,
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.primaryColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 7,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.whiteColor,
          foregroundColor: color,
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.02,
            horizontal: MediaQuery.of(context).size.width * 0.04,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        icon: Icon(icon, size: 24, color: color),
        label: Text(
          label,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildDetailCard({
    required String label,
    required String value,
    required double fontSize,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: fontSize * 0.9,
              color: AppColor.primaryColor,
              letterSpacing: 0.3,
            ),
            semanticsLabel: label.replaceFirst('💊 ', ''),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              color: AppColor.primaryColor.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
