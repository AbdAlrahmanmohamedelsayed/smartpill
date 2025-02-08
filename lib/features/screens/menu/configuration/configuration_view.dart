import 'package:flutter/material.dart';
import 'package:smartpill/features/screens/menu/configuration/layer/pill_layer_view.dart';
import 'package:smartpill/model/layer_model.dart';

class ConfigurationView extends StatefulWidget {
  @override
  _ConfigurationViewState createState() => _ConfigurationViewState();
}

class _ConfigurationViewState extends State<ConfigurationView> {
  List<LayerData> layers = [
    LayerData(
      medicineName: "Medicine 1",
      totalPills: 100,
      remainingPills: 50,
      selectedTone: "Default Tone",
      layerColor: Colors.red,
    ),
    LayerData(
      medicineName: "Medicine 2",
      totalPills: 200,
      remainingPills: 30,
      selectedTone: "Tone 1",
      layerColor: Colors.blueAccent,
    ),
    LayerData(
      medicineName: "Medicine 3",
      totalPills: 150,
      remainingPills: 70,
      selectedTone: "Tone 2",
      layerColor: Colors.green,
    ),
    LayerData(
      medicineName: "Medicine 4",
      totalPills: 120,
      remainingPills: 20,
      selectedTone: "Default Tone",
      layerColor: Colors.yellow,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pill Configuration"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: layers.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
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
                subtitle: Text(
                  "Remaining: ${layers[index].remainingPills} pills",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[800],
                  ),
                ),
                trailing: const Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PillLayerScreen(layerData: layers[index]),
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
    );
  }
}
