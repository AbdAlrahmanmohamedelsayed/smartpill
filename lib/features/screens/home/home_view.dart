import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final EasyInfiniteDateTimelineController _controller =
      EasyInfiniteDateTimelineController();
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
                color: ColorPallets.primaryColor,
                height: medi.size.height * .25,
                width: medi.size.width,
                alignment: Alignment.topLeft,
                child: Text(
                  'Home',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: ColorPallets.Colowhite),
                ),
              ),
              Positioned(
                top: 150,
                child: SizedBox(
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
                              color: ColorPallets.redColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Exo'),
                          monthStrStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Exo'),
                          dayStrStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Exo'),
                        ),
                        activeDayStyle: DayStyle(
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 2, color: ColorPallets.redColor),
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          dayNumStyle: const TextStyle(
                              color: ColorPallets.Colowhite,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Exo'),
                          monthStrStyle: const TextStyle(
                              color: ColorPallets.Colowhite,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Exo'),
                          dayStrStyle: const TextStyle(
                              color: ColorPallets.Colowhite,
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
      ],
    );
  }
}
