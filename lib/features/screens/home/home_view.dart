import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/features/screens/add_pill_reminder/addMedicine_view.dart';

import '../../../model/PillReminder.dart';

class HomeView extends StatefulWidget {
  final List<PillReminder> pillReminders;
  final Function(PillReminder) onSave;

  const HomeView({super.key, required this.onSave, required this.pillReminders});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final EasyInfiniteDateTimelineController _controller = EasyInfiniteDateTimelineController();
  var _focusDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var medi = MediaQuery.of(context);
    var theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 50),
                color: AppColor.primaryColor,
                height: medi.size.height * .25,
                width: medi.size.width,
                alignment: Alignment.topLeft,
                child: Text(
                  'Home',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColor.whiteColor,
                  ),
                ),
              ),
              Positioned(
                top: 150,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 4),
                        blurRadius: 15,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  width: medi.size.width,
                  child: EasyInfiniteDateTimeLine(
                    controller: _controller,
                    firstDate: DateTime(2024),
                    focusDate: _focusDate,
                    lastDate: DateTime(2025, 12, 31),
                    onDateChange: (selectedDate) {
                      setState(() {
                        _focusDate = selectedDate;
                      });
                    },
                    dayProps: EasyDayProps(
                        todayStyle: DayStyle(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          dayNumStyle: const TextStyle(
                              color: AppColor.primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Exo'),
                          monthStrStyle: const TextStyle(
                              color: AppColor.primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Exo'),
                          dayStrStyle: const TextStyle(
                              color: AppColor.primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Exo'),
                        ),
                        activeDayStyle: DayStyle(
                          decoration: BoxDecoration(
                            // border: Border.all(
                            //     width: 2, color: ColorPallets.redColor),
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          dayNumStyle: const TextStyle(
                              color: AppColor.whiteColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Exo'),
                          monthStrStyle: const TextStyle(
                              color: AppColor.whiteColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Exo'),
                          dayStrStyle: const TextStyle(
                              color: AppColor.whiteColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Exo'),
                        ),
                        inactiveDayStyle: DayStyle(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          dayNumStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins'),
                          monthStrStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins'),
                          dayStrStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins'),
                        )),
                    showTimelineHeader: false,
                  ),
                ),
              )
            ],
          ),
        ),
          // **Pill Reminder List**
          Expanded(
          child: widget.pillReminders.isEmpty
    ? const Center(
    child: Text(
    'No pills added yet.',
    style: TextStyle(fontSize: 16, color: Colors.grey),
    ),
    )
        : ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    itemCount: widget.pillReminders.length,
    itemBuilder: (context, index) {
    final reminder = widget.pillReminders[index];
    return Card(
    margin:
    const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10)),
    elevation: 3,
    child:SizedBox(
      height: 100,
      child: ListTile(
    title: Text(
    reminder.name,
    style: const TextStyle(
    fontSize: 16, fontWeight: FontWeight.bold),
    ),
    subtitle: Text(
    'Dosage: ${reminder.dosage} | Amount: ${reminder.amount} | Time: ${reminder.time.format(context)}',
    style: const TextStyle(fontSize: 14),
    ),
    ),
    ),
    );
    },
    ),)
      ],
    );
  }
}
