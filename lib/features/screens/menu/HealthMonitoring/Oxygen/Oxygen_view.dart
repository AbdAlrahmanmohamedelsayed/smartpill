import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:http/http.dart' as http;
import 'package:smartpill/features/screens/menu/HealthMonitoring/Oxygen/custom_history.dart';
import 'package:smartpill/model/oximeterData.dart';
import 'dart:convert';

class OxygenView extends StatefulWidget {
  const OxygenView({super.key});

  @override
  State<OxygenView> createState() => _OxygenViewState();
}

class _OxygenViewState extends State<OxygenView> {
  bool isMeasuring = false;
  List<VitalsMeasurement> measurements = [];
  double currentOxygenLevel = 0;
  int currentHeartRate = 0;

  // Simulate the sensor endpoint - replace with your actual endpoint
  final String sensorEndpoint = 'https://yoursensorapi.com/vitals';

  @override
  void initState() {
    super.initState();
    _loadMeasurements();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
        ),
        backgroundColor: AppColor.primaryColor,
        toolbarHeight: 80,
        titleTextStyle: theme.appBarTheme.titleTextStyle
            ?.copyWith(color: AppColor.whiteColor),
        title: const Text('Vitals Monitor'),
        leading: const BackButton(
          color: AppColor.whiteColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '1-Gently place your finger on the sensor so that it covers it completely.',
              style: theme.textTheme.bodySmall,
              maxLines: 2,
            ),
            const SizedBox(height: 40),
            Text(
              '2-Stay still and do not move while measuring.',
              style: theme.textTheme.bodySmall,
              maxLines: 2,
            ),
            const SizedBox(height: 40),
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              height: 300,
              width: 400,
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 4),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(height: 100, 'assets/images/icons/oxygen.png'),
                  const SizedBox(height: 20),
                  if (isMeasuring)
                    Column(
                      children: [
                        const CircularProgressIndicator(
                          color: AppColor.primaryColor,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Measuring your vitals...',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  if (!isMeasuring &&
                      (currentOxygenLevel > 0 || currentHeartRate > 0))
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.healing,
                                color: AppColor.primaryColor),
                            const SizedBox(width: 8),
                            Text(
                              'SpO₂: ${currentOxygenLevel.toStringAsFixed(1)}%',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.favorite, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(
                              'Heart Rate: $currentHeartRate BPM',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isMeasuring ? Colors.grey : AppColor.primaryColor,
                padding: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: isMeasuring ? null : _startMeasurement,
              child: Text(
                isMeasuring ? 'Measuring...' : 'Start Measurement',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: AppColor.whiteColor),
              ),
            ),
            const SizedBox(height: 20),
            if (measurements.isNotEmpty)
              Expanded(
                // Use our custom widget instead of the previous implementation
                child: VitalsHistoryWidget(
                  measurements: measurements,
                  onItemTap: (measurement) {
                    // Handle tap on measurement item - show details
                    _showMeasurementDetails(measurement);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Show a detailed view of the measurement
  void _showMeasurementDetails(VitalsMeasurement measurement) {
    showModalBottomSheet(
      backgroundColor: AppColor.backgroundColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Measurement Details',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text('Date'),
                subtitle: Text(measurement.formattedDate),
              ),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: Text('Time'),
                subtitle: Text(measurement.formattedTime),
              ),
              ListTile(
                leading:
                    const Icon(Icons.healing, color: AppColor.primaryColor),
                title: Text('Oxygen Level'),
                subtitle:
                    Text('${measurement.oxygenLevel.toStringAsFixed(1)}%'),
              ),
              ListTile(
                leading: const Icon(Icons.favorite, color: Colors.red),
                title: Text('Heart Rate'),
                subtitle: Text('${measurement.heartRate} BPM'),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Future<void> _startMeasurement() async {
    setState(() {
      isMeasuring = true;
    });

    try {
      // Simulate measuring time (5 seconds)
      await Future.delayed(const Duration(seconds: 5));

      // Make the actual API call to get sensor data
      await _sendRequest(sensorEndpoint);

      // For testing, generate random data if API fails
      if (currentOxygenLevel == 0 && currentHeartRate == 0) {
        // Generate realistic random values
        final double oxygenValue = 95 + (DateTime.now().millisecond % 5);
        final int heartRateValue = 70 + (DateTime.now().second % 30);

        setState(() {
          currentOxygenLevel = oxygenValue;
          currentHeartRate = heartRateValue;
        });
      }

      // Create a new measurement and add it to the list
      final newMeasurement = VitalsMeasurement(
        oxygenLevel: currentOxygenLevel,
        heartRate: currentHeartRate,
        timestamp: DateTime.now(),
      );

      setState(() {
        measurements.insert(0, newMeasurement); // Add to beginning of list
        // Optionally limit the list size
        if (measurements.length > 10) {
          measurements = measurements.sublist(0, 10);
        }
      });

      // Save measurements to local storage
      _saveMeasurements();
    } catch (e) {
      print('Error during measurement: $e');
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to measure vitals: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isMeasuring = false;
      });
    }
  }

  Future<void> _sendRequest(String endpoint) async {
    final url = Uri.parse(endpoint);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('API Call Successful: ${response.body}');
        // Parse the response - adjust according to your API response format
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          currentOxygenLevel = data['oxygen'] ?? 0.0;
          currentHeartRate = data['heartRate'] ?? 0;
        });
      } else {
        print('API Call Failed with Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred during API call: $e');
    }
  }

  // Save measurements to persistent storage
  Future<void> _saveMeasurements() async {
    // Implement storage logic here
  }

  // Load measurements from storage
  Future<void> _loadMeasurements() async {
    // Implement loading logic here
  }
}
