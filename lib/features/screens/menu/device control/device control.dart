import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/features/screens/menu/connect_device/custom_button.dart';

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
            Image.asset(width: 100, 'assets/images/logo.png'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomElevatedButton(
                    onPressed: () => _sendRequest('http://192.168.4.1/reload'),
                    text: 'Reload Medicine',
                    imagePath: 'assets/images/icons/Reload_Medicin.png'),
                CustomElevatedButton(
                    onPressed: () =>
                        _sendRequest('http://192.168.4.1/moveoneangle'),
                    text: 'Move One Angle',
                    imagePath: 'assets/images/icons/Move_Angle.png'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomElevatedButton(
                    onPressed: () =>
                        _sendRequest('http:// 192.168.4.1/ReloadWithSensor'),
                    text: 'Reload With Sensor',
                    imagePath: 'assets/images/icons/Reload_Sensor.png'),
                CustomElevatedButton(
                    onPressed: () =>
                        _sendRequest('http://192.168.4.1/dereleaseone'),
                    text: 'Take One pill',
                    imagePath: 'assets/images/icons/take-medicines.png')
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
