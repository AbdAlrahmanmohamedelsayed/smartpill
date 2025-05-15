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
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _imagePulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: 300),
      child: Dialog.fullscreen(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.primaryColor.withOpacity(0.9),
                Colors.amber[700]!.withOpacity(0.7), // Gold color
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Glassmorphic overlay
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    backgroundBlendMode: BlendMode.overlay,
                  ),
                ),
                // Close button at top-right
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.04),
                    child: Semantics(
                      label: 'Close medication reminder',
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.white, size: 32),
                        onPressed: () {
                          widget.stopAlarmSound();
                          Navigator.of(context).pop();
                        },
                        tooltip: 'Dismiss Alarm',
                        splashRadius: 24,
                      ),
                    ),
                  ),
                ),
                // Main content
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Header
                      Text(
                        'Medication Reminder',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: MediaQuery.of(context).size.width *
                              0.06, // Smaller title
                          shadows: [
                            Shadow(
                              blurRadius: 6,
                              color: Colors.black.withOpacity(0.4),
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // Medication image with pulse animation
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: ScaleTransition(
                            scale: Tween(begin: 1.0, end: 1.15)
                                .animate(_imagePulseController),
                            child: Image.asset(
                              'assets/images/icons/medicine_icon.png',
                              width: MediaQuery.of(context).size.width * 0.24,
                              height: MediaQuery.of(context).size.width * 0.24,
                              fit: BoxFit.contain,
                              semanticLabel: 'Medication Reminder Icon',
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                Icons.medication,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width * 0.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Medication details (horizontal distribution)
                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildDetailColumn(
                              label: '💊 Medication:',
                              value: widget.data.name,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              textColor: Colors.white,
                            ),
                            _buildDetailColumn(
                              label: '💊 Dose:',
                              value: '${widget.data.dose} mg',
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              textColor: Colors.white,
                            ),
                            _buildDetailColumn(
                              label: 'Time:',
                              value: MaterialLocalizations.of(context)
                                  .formatTimeOfDay(widget.time),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              textColor: Colors.white,
                            ),
                            _buildDetailColumn(
                              label: 'Pills:',
                              value: '${widget.data.amount}',
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              textColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      // Action buttons
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildAnimatedButton(
                              icon: Icons.check_circle,
                              label: 'Taken',
                              color: Colors.amber[700]!, // Gold color
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
                                  hour: (now.hour + ((now.minute + 15) ~/ 60)) %
                                      24,
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
      ),
    );
  }

  Widget _buildAnimatedButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool _isTapped = false;
        return GestureDetector(
          onTapDown: (_) => setState(() => _isTapped = true),
          onTapUp: (_) {
            setState(() => _isTapped = false);
            onPressed();
          },
          onTapCancel: () => setState(() => _isTapped = false),
          child: AnimatedScale(
            scale: _isTapped ? 0.92 : 1.0,
            duration: Duration(milliseconds: 150),
            child: Container(
              width: MediaQuery.of(context).size.width *
                  0.35, // Smaller button width
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0.6)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 3,
                    offset: Offset(-1, -1),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: color,
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.015,
                    horizontal: MediaQuery.of(context).size.width * 0.03,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                icon: Icon(
                  icon,
                  size: 20, // Smaller icon
                  color: color,
                ),
                label: Text(
                  label,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width *
                        0.035, // Smaller text
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {}, // Handled by GestureDetector
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailColumn({
    required String label,
    required String value,
    required double fontSize,
    Color textColor = Colors.black,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width *
          0.22, // Compact width for horizontal layout
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 3),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(-1, -1),
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
              fontWeight: FontWeight.w800,
              fontSize: fontSize * 0.85,
              color: textColor,
              letterSpacing: 0.5,
            ),
            semanticsLabel: label.replaceFirst('💊 ', ''),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              color: textColor.withOpacity(0.9),
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
