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
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _imagePulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog.fullscreen(
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: screenHeight * 0.02,
                right: screenWidth * 0.04,
                child: Semantics(
                  label: 'Close medication reminder',
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: theme.colorScheme.primary,
                      size: screenWidth * 0.06,
                    ),
                    onPressed: () {
                      widget.stopAlarmSound();
                      Navigator.of(context).pop();
                    },
                    tooltip: 'Dismiss Alarm',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      shape: const CircleBorder(),
                      padding: EdgeInsets.all(screenWidth * 0.015),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: screenHeight * 0.06,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Medication Reminder',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: screenWidth * 0.055,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: ScaleTransition(
                          scale: Tween(begin: 1.5, end: 1.08).animate(
                            CurvedAnimation(
                              parent: _imagePulseController,
                              curve: Curves.easeInOutQuad,
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/icons/medicine_icon.png',
                            width: screenWidth * 0.4,
                            height: screenWidth * 0.4,
                            fit: BoxFit.contain,
                            semanticLabel: 'Medication Reminder Icon',
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.medication,
                              color: theme.colorScheme.primary,
                              size: screenWidth * 0.18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Expanded(
                      flex: 3,
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: screenWidth * 0.05,
                        mainAxisSpacing: screenHeight * 0.04,
                        childAspectRatio: 1.9,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildDetailCard(
                            label: '💊 Medication',
                            value: widget.data.name,
                            fontSize: screenWidth * 0.04,
                            theme: theme,
                          ),
                          _buildDetailCard(
                            label: '💊 Dose',
                            value: '${widget.data.dose} mg',
                            fontSize: screenWidth * 0.04,
                            theme: theme,
                          ),
                          _buildDetailCard(
                            label: 'Time',
                            value: MaterialLocalizations.of(context)
                                .formatTimeOfDay(widget.time),
                            fontSize: screenWidth * 0.04,
                            theme: theme,
                          ),
                          _buildDetailCard(
                            label: 'Pills',
                            value: '${widget.data.amount}',
                            fontSize: screenWidth * 0.04,
                            theme: theme,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildAnimatedButton(
                            icon: Icons.check_circle,
                            label: 'Taken',
                            color: AppColor.accentGreen,
                            onPressed: () async {
                              setState(() {
                                widget.checkedStatus[widget.time] = true;
                              });
                              widget.stopAlarmSound();
                              await widget
                                  .sendRequest('http://192.168.4.1/Alarm');
                              if (widget.resMassage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'API Response: ${widget.resMassage}',
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSecondary,
                                      ),
                                    ),
                                    duration: const Duration(seconds: 2),
                                    backgroundColor:
                                        theme.colorScheme.secondary,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              }
                              widget.scheduleAlarms();
                              Navigator.of(context).pop();
                            },
                            theme: theme,
                          ),
                          _buildAnimatedButton(
                            icon: Icons.snooze,
                            label: 'Snooze',
                            color: AppColor.buttonPrimary,
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
                            theme: theme,
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
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: MediaQuery.of(context).size.width * 0.35,
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.015,
          horizontal: MediaQuery.of(context).size.width * 0.03,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.7)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: AppColor.whiteColor),
            SizedBox(width: MediaQuery.of(context).size.width * 0.015),
            Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required String label,
    required String value,
    required double fontSize,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
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
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: fontSize * 0.9,
              color: theme.colorScheme.primary,
              letterSpacing: 0.4,
            ),
            semanticsLabel: label.replaceFirst('💊 ', ''),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: fontSize,
              color: theme.colorScheme.primary.withOpacity(0.9),
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
