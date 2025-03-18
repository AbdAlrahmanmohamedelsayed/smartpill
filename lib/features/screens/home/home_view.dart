import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/features/screens/add_pill_reminder/data/medicine-Provider.dart';
import 'package:smartpill/features/screens/add_pill_reminder/presentation/ui/update_medicine.dart';
import 'package:smartpill/features/screens/add_pill_reminder/presentation/widgets/custom_medicine_item.dart';
import 'package:smartpill/utils/token_manager.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String profileName = 'User';
  bool isLoading = true;
  final EasyInfiniteDateTimelineController _controller =
      EasyInfiniteDateTimelineController();
  var _focusDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MedicineProvider>(context, listen: false).loadMedicines();
    });
  }

  @override
  Widget build(BuildContext context) {
    var medi = MediaQuery.of(context);
    var theme = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                  color: AppColor.primaryColor,
                  height: medi.size.height * .25,
                  width: medi.size.width,
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Welcome, ${profileName} 👋",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColor.whiteColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Positioned(
                  top: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(0, 4),
                          blurRadius: 9,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    width: medi.size.width,
                    child: EasyInfiniteDateTimeLine(
                      controller: _controller,
                      firstDate: DateTime(2025),
                      focusDate: _focusDate,
                      lastDate: DateTime(2026, 12, 31),
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
          RefreshIndicator(
            color: AppColor.primaryColor,
            backgroundColor: AppColor.whiteColor,
            onRefresh: () async {
              await Provider.of<MedicineProvider>(context, listen: false)
                  .loadMedicines();
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Consumer<MedicineProvider>(
                builder: (context, medicineProvider, child) {
                  if (medicineProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.primaryColor,
                      ),
                    );
                  } else if (medicineProvider.errorMessage != null) {
                    return Center(
                      child: Text(medicineProvider.errorMessage!),
                    );
                  } else if (medicineProvider.medicines.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                            width: 170, 'assets/images/icons/no-drugs.png'),
                        const SizedBox(height: 16),
                        Text(
                          "you don't have any medicine to take 💊",
                          style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColor.errorColor),
                        ),
                      ],
                    );
                  } else {
                    return ListView.separated(
                      separatorBuilder: (context, index) => const Divider(
                        thickness: 3,
                        endIndent: 35,
                        indent: 35,
                        color: AppColor.textColorHint,
                      ),
                      itemCount: medicineProvider.medicines.length,
                      itemBuilder: (context, index) {
                        final medicine = medicineProvider.medicines[index];
                        return CustomMedicineItem(
                          data: medicine,
                          onEdit: () async {
                            final updatedMedicine = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditMedicineView(medicine: medicine),
                              ),
                            );

                            if (updatedMedicine != null) {
                              bool success = await medicineProvider
                                  .updateMedicine(updatedMedicine);
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Medicine updated successfully')),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Failed to update medicine')),
                                );
                              }
                            }
                          },
                          onDelete: () async {
                            bool confirmDelete = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Confirm Delete',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: AppColor.errorColor,
                                        ),
                                      ),
                                      content: const Text(
                                          'Are you sure you want to delete this medicine?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                ) ??
                                false;
                            if (confirmDelete) {
                              if (medicine.id != null) {
                                bool success = await medicineProvider
                                    .deleteMedicine(medicine.id!);
                                print(medicine.id);
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Medicine deleted successfully')),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Failed to delete medicine')),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Medicine ID is null')),
                                );
                              }
                            }
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadProfileData() async {
    try {
      final tokenData = await TokenManager.getToken();
      final dispalyName = tokenData['displayName'];

      setState(() {
        if (dispalyName != null && dispalyName.isNotEmpty) {
          profileName = dispalyName;
        }
        isLoading = false;
      });
    } catch (e) {
      print('Error loading profile data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
}
