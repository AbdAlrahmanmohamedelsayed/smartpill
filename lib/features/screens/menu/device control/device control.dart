import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartpill/core/theme/color_pallets.dart';

class TestView extends StatelessWidget {
  const TestView({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Device control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.accentGreen,
                    foregroundColor: AppColor.textColorPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 22),
                  ),
                  onPressed: () => _sendRequest('http://192.168.4.1/reload'),
                  child: Column(
                    children: [
                      Image.asset(
                          width: 60, 'assets/images/icons/reload_pill.png'),
                      const SizedBox(height: 5),
                      const Text('Reload Medicine'),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.accentGreen,
                    foregroundColor: AppColor.textColorPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 22),
                  ),
                  onPressed: () =>
                      _sendRequest('http://192.168.4.1/moveoneangle'),
                  child: Column(
                    children: [
                      Image.asset(
                          width: 60, 'assets/images/icons/Move_One.png'),
                      const SizedBox(height: 5),
                      const Text('Move One Angle'),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.accentGreen,
                    foregroundColor: AppColor.textColorPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 22),
                  ),
                  onPressed: () =>
                      _sendRequest('http://192.168.4.1/ReloadWithSenso'),
                  child: Column(
                    children: [
                      Image.asset(
                          width: 60,
                          'assets/images/icons/ultrasonic-sensor.png'),
                      const SizedBox(height: 5),
                      const Text('Reload With Sensor'),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.accentGreen,
                    foregroundColor: AppColor.textColorPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 22),
                  ),
                  onPressed: () =>
                      _sendRequest('http://192.168.4.1/dereleaseone'),
                  child: Column(
                    children: [
                      Image.asset(
                          width: 70, 'assets/images/icons/Release_one.png'),
                      const SizedBox(height: 5),
                      const Text(
                        'Release One',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendRequest(String endpoint) async {
    final url = Uri.parse(endpoint);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('API Call Successful: ${response.body}');
        // Optionally, handle response data
      } else {
        print('API Call Failed with Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred during API call: $e');
    }
  }
}
