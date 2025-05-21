import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/features/screens/add_pill_reminder/presentation/widgets/medicine_reminder.dart';
import 'package:smartpill/model/data_medicine.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

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
  late Map<TimeOfDay, bool> checkedStatus;
  List<Timer> _alarmTimers = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? resMassage;
  bool _isAlarmPlaying = false;
  bool _useFallbackPlayer = false;

  @override
  void initState() {
    super.initState();
    checkedStatus = {for (var time in widget.data.reminderTimes) time: false};
    _initAudioPlayer();
    _scheduleAlarms();
    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        _isAlarmPlaying = state.playing;
        print(
            'Audio player state: ${state.processingState}, playing: ${state.playing}');
      });
    });
  }

  Future<void> _initAudioPlayer() async {
    try {
      print('Initializing audio player...');
      await _audioPlayer.setLoopMode(LoopMode.one);
      await _audioPlayer.setAsset('assets/sounds/alarm.mp3');
      await _audioPlayer.setVolume(1.0);
      print('Audio player initialized successfully');
    } catch (e) {
      print('Error initializing audio player: $e');
      setState(() {
        _useFallbackPlayer = true;
      });
    }
  }

  void _scheduleAlarms() {
    _cancelAlarms();

    final now = DateTime.now();
    for (var time in widget.data.reminderTimes) {
      if (_isTimeChecked(time)) continue;

      DateTime alarmTime = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      if (alarmTime.isBefore(now)) {
        alarmTime = alarmTime.add(const Duration(days: 1));
      }

      final duration = alarmTime.difference(now);

      print('Scheduling alarm for $time in ${duration.inSeconds} seconds');

      Timer timer = Timer(duration, () {
        if (mounted && !_isTimeChecked(time)) {
          _triggerAlarm(time);
          _scheduleAlarms();
        }
      });

      _alarmTimers.add(timer);
    }
  }

  void _cancelAlarms() {
    for (var timer in _alarmTimers) {
      timer.cancel();
    }
    _alarmTimers.clear();
  }

  bool _isTimeChecked(TimeOfDay time) {
    return checkedStatus[time] ?? false;
  }

  void _triggerAlarm(TimeOfDay time) {
    print('Triggering alarm for time: $time');
    _playAlarmSound();
    _showMedicationDetailsDialog(time);
  }

  Future<void> _playAlarmSound() async {
    if (_isAlarmPlaying) {
      print('Alarm is already playing, skipping...');
      return;
    }

    if (_useFallbackPlayer) {
      try {
        print('Using fallback player (flutter_ringtone_player)...');
        await FlutterRingtonePlayer().play(
          android: AndroidSounds.alarm,
          ios: IosSounds.alarm,
          looping: true,
          volume: 1.0,
          asAlarm: true,
        );
        setState(() {
          _isAlarmPlaying = true;
        });
        print('Fallback alarm sound playing.');
      } catch (e) {
        print('Error playing fallback sound: $e');
      }
      return;
    }

    try {
      print('Attempting to play alarm sound with just_audio...');
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.play();
      print('Alarm sound should be playing now.');
    } catch (e) {
      print('Error playing sound: $e');
      print('Retrying with re-initialization...');
      await _initAudioPlayer();
      try {
        await _audioPlayer.play();
        print('Retry playing sound succeeded.');
      } catch (retryError) {
        print('Retry playing sound failed: $retryError');
        setState(() {
          _useFallbackPlayer = true;
        });
        await _playAlarmSound();
      }
    }
  }

  Future<void> _stopAlarmSound() async {
    try {
      print('Stopping alarm sound...');
      if (_useFallbackPlayer) {
        await FlutterRingtonePlayer().stop();
        print('Fallback alarm sound stopped.');
      } else {
        await _audioPlayer.pause();
        print('Just_audio alarm sound paused.');
      }
      setState(() {
        _isAlarmPlaying = false;
      });
    } catch (e) {
      print('Error stopping sound: $e');
    }
  }

  Future<void> _sendRequest(String endpoint) async {
    final url = Uri.parse(endpoint);
    try {
      print('Sending API request to: $endpoint');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('API call successful: ${response.body}');
        setState(() {
          resMassage = response.body;
        });
        await Future.delayed(const Duration(milliseconds: 500));
        await _sendDeviceSoundRequest();
      } else {
        print('API call failed with status code: ${response.statusCode}');
        setState(() {
          resMassage = 'Failed: ${response.statusCode}';
        });
      }
    } catch (e) {
      print('Error occurred during API call: $e');
      setState(() {
        resMassage = 'Error: $e';
      });
    }
  }

  Future<void> _sendDeviceSoundRequest() async {
    final url = Uri.parse('http://192.168.4.1/PlaySound');
    try {
      print('Sending sound request to device...');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('Sound request successful: ${response.body}');
      } else {
        print('Sound request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending sound request: $e');
    }
  }

  void _showMedicationDetailsDialog(TimeOfDay time) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MedicationReminderDialog(
        time: time,
        data: widget.data,
        stopAlarmSound: _stopAlarmSound,
        sendRequest: _sendRequest,
        scheduleAlarms: _scheduleAlarms,
        checkedStatus: checkedStatus,
        resMassage: resMassage,
      ),
    );
  }

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
      final formatter = DateFormat('dd MMM yyyy');
      return formatter.format(date);
    } catch (e) {
      return dateInput.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      SizedBox(width: screenWidth * 0.03),
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
              SizedBox(height: 10),
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
                  return _buildTimeChipWithAlarm(
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
    IconData? fallbackIcon,
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
        child: fallbackIcon != null
            ? Icon(
                fallbackIcon,
                color: Colors.white,
                size: size * 0.6,
              )
            : Image.asset(
                imagePath,
                width: size,
                height: size,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.error,
                    color: Colors.white,
                    size: size * 0.6,
                  );
                },
              ),
      ),
    );
  }

  Widget _buildTimeChipWithAlarm({
    required String text,
    required double fontSize,
    required TimeOfDay time,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: () {
          setState(() {
            checkedStatus[time] = !(checkedStatus[time] ?? false);
            _scheduleAlarms();
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
      ),
    );
  }

  @override
  void dispose() {
    _cancelAlarms();
    _audioPlayer.dispose();
    FlutterRingtonePlayer().stop();
    super.dispose();
  }
}
