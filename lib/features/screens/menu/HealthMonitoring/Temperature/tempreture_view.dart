import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Import for date formatting
import 'dart:async'; // Import for timeout

class TempretureView extends StatefulWidget {
  const TempretureView({super.key});

  @override
  State<TempretureView> createState() => _TempretureViewState();
}

class _TempretureViewState extends State<TempretureView> {
  String temperature = '37';
  String measurementTime = '';
  bool isLoading = false;
  bool isShowingResult = false;

  // List to store measurement history
  List<Map<String, String>> measurementHistory = [];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
        ),
        backgroundColor: AppColor.primaryColor,
        toolbarHeight: 80,
        titleTextStyle: theme.appBarTheme.titleTextStyle
            ?.copyWith(color: AppColor.whiteColor),
        title: const Text('Temperature'),
        leading: const BackButton(
          color: AppColor.whiteColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
          child: Column(
            children: [
              // Instructions Card
              Card(
                color: AppColor.whiteColor,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: AppColor.primaryColor),
                          SizedBox(width: 8),
                          Text(
                            "Instructions",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '1-Gently place your finger on the sensor. Make sure your finger completely covers the sensor to ensure an accurate reading',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '2-Stay still during measurement. Avoid any movement during the process to get an accurate result.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Measurement Container
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                padding: const EdgeInsets.all(20),
                height: 320,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      offset: const Offset(0, 4),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: _buildCentralContent(),
              ),

              // Measurement Button
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () => _sendRequest('http://192.168.4.1/temperature'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                  ),
                  child: Text(
                    isLoading ? 'Measuring...' : 'Measure Temperature',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Measurement History
              if (measurementHistory.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.history, color: AppColor.primaryColor),
                          SizedBox(width: 8),
                          Text(
                            'Measurement History',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: measurementHistory.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final measurement = measurementHistory[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColor.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.thermostat,
                                    color: AppColor.primaryColor,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${measurement['temperature']}°C',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        measurement['time'] ?? '',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      measurementHistory.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCentralContent() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(
              color: AppColor.primaryColor,
              strokeWidth: 6.0,
            ),
            SizedBox(height: 20),
            Text(
              'Measuring Temperature...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Please keep your finger on the sensor',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    } else if (isShowingResult) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.thermostat,
                size: 80,
                color: AppColor.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '$temperature°C',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    measurementTime,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Lottie.asset(width: 400, 'assets/images/Lottie/temper.json');
    }
  }

  Future<void> _sendRequest(String endpoint) async {
    setState(() {
      isLoading = true;
      isShowingResult = false;
    });

    final url = Uri.parse(endpoint);
    try {
      // Use timeout to wait for 2 minutes (120 seconds) before giving up
      final response = await http.get(url).timeout(
        const Duration(seconds: 120),
        onTimeout: () {
          // Return null on timeout - this will be caught in the catch block
          throw TimeoutException('API request timed out after 120 seconds');
        },
      );

      if (response.statusCode == 200 && response.body.trim().isNotEmpty) {
        print('API Call Successful: ${response.body}');

        final currentTime =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
        final tempValue = response.body.trim();

        setState(() {
          temperature = tempValue;
          measurementTime = currentTime;

          // Add to measurement history
          measurementHistory.insert(0, {
            'temperature': tempValue,
            'time': currentTime,
          });

          isLoading = false;
          isShowingResult = true;
        });
      } else {
        print(
            'API Call Failed with Status Code: ${response.statusCode} or empty body');
        // Don't record anything if the response is empty or failed
        setState(() {
          isLoading = false;
          isShowingResult = false;
        });
      }
    } catch (e) {
      print('Error occurred during API call: $e');
      // Don't record anything on error/timeout
      setState(() {
        isLoading = false;
        isShowingResult = false;
      });
    }
  }

  void _handleFailedMeasurement() {
    final currentTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    setState(() {
      temperature = '37';
      measurementTime = currentTime;

      measurementHistory.insert(0, {
        'temperature': '37',
        'time': currentTime,
      });

      isLoading = false;
      isShowingResult = true;
    });
  }
}
