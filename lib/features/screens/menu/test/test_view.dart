import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TestView extends StatelessWidget {
  const TestView({super.key});

  // Function to send API requests
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test View'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _sendRequest('http://192.168.4.1/reload'),
              child: const Text('Reload Medicine'),
            ),
            const SizedBox(height: 10), // Spacing between buttons
            ElevatedButton(
              onPressed: () => _sendRequest('http://192.168.4.1/dereleaseone'),
              child: const Text('Release One'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _sendRequest('http://192.168.4.1/moveoneangle'),
              child: const Text('Move One Angle'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () =>
                  _sendRequest('http://192.168.4.1/ReloadWithSenso'),
              child: const Text('Reload With Sensor'),
            ),
          ],
        ),
      ),
    );
  }
}
