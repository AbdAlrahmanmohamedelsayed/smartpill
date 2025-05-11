import 'package:flutter/material.dart';
import 'package:smartpill/features/screens/menu/configuration/layer/pill_layer_view.dart';
import 'package:smartpill/model/layer_model.dart';
import 'package:http/http.dart' as http;

class ConfigurationView extends StatefulWidget {
  @override
  _ConfigurationViewState createState() => _ConfigurationViewState();
}

class _ConfigurationViewState extends State<ConfigurationView> {
  String remainingPills = "0";
  bool isLoadingPills = true; // Loading state specifically for pills count
  bool hasError = false; // Flag to show error state

  // Store the actual value from API to pass to other screens
  int actualRemainingPills = 0;

  List<LayerData> layers = [
    LayerData(
      medicineName: "Medicine 1",
      totalPills: 26,
      remainingPills: 0,
      selectedTone: "Default Tone",
      layerColor: Colors.red,
    ),
    LayerData(
      medicineName: "Medicine 2",
      totalPills: 26,
      remainingPills: 0,
      selectedTone: "Tone 1",
      layerColor: Colors.blueAccent,
    ),
    LayerData(
      medicineName: "Medicine 3",
      totalPills: 26,
      remainingPills: 0,
      selectedTone: "Tone 2",
      layerColor: Colors.green,
    ),
    LayerData(
      medicineName: "Medicine 4",
      totalPills: 26,
      remainingPills: 0,
      selectedTone: "Default Tone",
      layerColor: Colors.yellow,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchRemainingPills();
  }

  Future<void> _fetchRemainingPills() async {
    setState(() {
      isLoadingPills = true;
      hasError = false;
    });

    final endpoint = "http://192.168.4.1/NumberOfPills";
    final url = Uri.parse(endpoint);

    try {
      final response = await http.get(url).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          return http.Response('Timeout', 408);
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          remainingPills = response.body;
          isLoadingPills = false;

          // Store the actual API value in a separate variable
          actualRemainingPills = int.tryParse(response.body) ?? 0;

          // Update the layer data objects with the API value
          for (int i = 0; i < layers.length; i++) {
            layers[i] = layers[i].copyWith(
              remainingPills: actualRemainingPills,
            );
          }
        });
      } else {
        setState(() {
          remainingPills = "0";
          isLoadingPills = false;
          hasError = true;
          actualRemainingPills = 0;
        });
      }
    } catch (e) {
      setState(() {
        remainingPills = "0";
        isLoadingPills = false;
        hasError = true;
        actualRemainingPills = 0;
      });
      print('Error occurred during API call: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Device Configuration"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchRemainingPills,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Pills count section with loading indicator on the text itself
            SizedBox(height: 16),
            // Layers list
            Expanded(
              child: ListView.separated(
                itemCount: layers.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 22,
                        horizontal: 16,
                      ),
                      tileColor: layers[index].layerColor.withOpacity(0.7),
                      title: Text(
                        "Layer ${index + 1}: ${layers[index].medicineName}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      subtitle: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          // Make text more transparent when loading
                          Text(
                            "Remaining: ${isLoadingPills ? "" : actualRemainingPills} pills",
                            style: TextStyle(
                              fontSize: 18,
                              color: isLoadingPills
                                  ? Colors.grey[800]?.withOpacity(0.3)
                                  : Colors.grey[800],
                            ),
                          ),
                          // Show loading indicator when loading
                          if (isLoadingPills)
                            Container(
                              margin: EdgeInsets.only(left: 85),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.settings,
                        color: Colors.black,
                      ),
                      onTap: () async {
                        // Pass both the layer data and the actual remaining pills value
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PillLayerScreen(
                              layerData: layers[index],
                              actualRemainingPills:
                                  actualRemainingPills, // Pass the actual API value
                            ),
                          ),
                        );

                        if (result != null && result is LayerData) {
                          setState(() {
                            layers[index] = result;
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
