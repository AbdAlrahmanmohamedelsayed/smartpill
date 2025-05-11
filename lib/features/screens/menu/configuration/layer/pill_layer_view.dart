import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:smartpill/model/layer_model.dart';
import 'package:http/http.dart' as http;

class PillLayerScreen extends StatefulWidget {
  final LayerData layerData;
  final int actualRemainingPills; // القيمة الفعلية من API

  const PillLayerScreen({
    Key? key,
    required this.layerData,
    required this.actualRemainingPills, // إضافة بارامتر جديد
  }) : super(key: key);

  @override
  _PillLayerScreenState createState() => _PillLayerScreenState();
}

class _PillLayerScreenState extends State<PillLayerScreen> {
  late TextEditingController _medicineNameController;
  late TextEditingController _remainingPillsController;
  late TextEditingController _totalPillsController;
  File? _medicineImage;
  late String selectedTone;
  late Color layerColor;

  @override
  void initState() {
    super.initState();
    _medicineNameController =
        TextEditingController(text: widget.layerData.medicineName);

    // استخدام القيمة الفعلية من API بدلاً من القيمة الموجودة في layerData
    _remainingPillsController =
        TextEditingController(text: widget.actualRemainingPills.toString());

    _totalPillsController =
        TextEditingController(text: widget.layerData.totalPills.toString());
    selectedTone = widget.layerData.selectedTone;
    layerColor = widget.layerData.layerColor;
    _medicineImage = widget.layerData.medicineImage;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Layer Settings",
          style: theme.textTheme.bodyMedium?.copyWith(color: layerColor),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Medicine Name:",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              style: theme.textTheme.bodyMedium,
              controller: _medicineNameController,
              decoration: InputDecoration(
                labelText: "Enter medicine name",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Medicine Image:",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                final picker = ImagePicker();
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);

                if (pickedFile != null) {
                  setState(() {
                    _medicineImage = File(pickedFile.path);
                  });
                }
              },
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: _medicineImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "Tap to upload image",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColor.textColorHint,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: AppColor.textColorHint,
                          ),
                        ],
                      )
                    : Image.file(_medicineImage!, fit: BoxFit.fitHeight),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Notification Tone:",
              style: theme.textTheme.bodyMedium,
            ),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedTone,
              dropdownColor: Colors.white,
              items: [
                DropdownMenuItem(
                    value: "Default Tone",
                    child: Text(
                      "Default Tone",
                      style: theme.textTheme.bodyMedium,
                    )),
                DropdownMenuItem(
                    value: "1",
                    child: Text(
                      "Tone 1",
                      style: theme.textTheme.bodySmall,
                    )),
                DropdownMenuItem(
                  value: "2",
                  child: Text(
                    "Tone 2",
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                DropdownMenuItem(
                  value: "3",
                  child: Text(
                    "Tone 3",
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedTone = value!;
                });
              },
            ),
            const SizedBox(height: 10),
            Text(
              "Remaining Pills:",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              readOnly: true,
              style: theme.textTheme.bodyMedium,
              controller: _remainingPillsController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Total Pills Capacity:",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              // readOnly: true,
              style: theme.textTheme.bodyMedium,
              controller: _totalPillsController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: "Enter total pills capacity",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: layerColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13))),
              onPressed: () {
                setState(() {
                  _remainingPillsController.text = _totalPillsController.text;
                });
                _sendRequest('http://192.168.4.1/reloadSensor');
              },
              icon: const Icon(
                Icons.refresh,
                size: 22,
                color: AppColor.whiteColor,
              ),
              label: Text(
                "Refill Layer",
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColor.whiteColor, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: layerColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13))),
              onPressed: () {
                final updatedLayer = LayerData(
                  medicineName: _medicineNameController.text,
                  totalPills: int.tryParse(_totalPillsController.text) ?? 0,
                  remainingPills:
                      int.tryParse(_remainingPillsController.text) ?? 0,
                  selectedTone: selectedTone,
                  layerColor: layerColor,
                  medicineImage: _medicineImage,
                );
                _sendRequest(
                    'http://192.168.4.1/setMedicineName?name=${_medicineNameController.text}&tone=$selectedTone');
                Navigator.pop(context, updatedLayer);
              },
              icon: const Icon(
                Icons.save,
                size: 22,
                color: AppColor.whiteColor,
              ),
              label: Text(
                "Save Settings",
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColor.whiteColor, fontWeight: FontWeight.bold),
              ),
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
