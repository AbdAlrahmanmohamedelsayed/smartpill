import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:smartpill/core/theme/color_pallets.dart';

class ConnectDevice extends StatefulWidget {
  const ConnectDevice({super.key});

  @override
  State<ConnectDevice> createState() => _ConnectDeviceState();
}

class _ConnectDeviceState extends State<ConnectDevice> {
  bool isDeviceConnected = false;
  String? connectedDeviceCode;

  void _connectToDevice(String code) {
    setState(() {
      isDeviceConnected = true;
      connectedDeviceCode = code;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Device connected: $code')),
    );
  }

  void _showScanner(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Scan QR Code"),
        content: SizedBox(
          height: 300,
          width: 300,
          child: MobileScanner(
            onDetect: (BarcodeCapture capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                String scannedCode = barcodes.first.rawValue!;
                Navigator.pop(context);
                _connectToDevice(scannedCode);
              }
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
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
        title: const Text('Connect Device'),
        leading: const BackButton(color: AppColor.whiteColor),
      ),
      body: Center(
        child: isDeviceConnected
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                      width: 200, height: 200, 'assets/images/logo.png'),
                  const SizedBox(height: 20),
                  Text('Device successfully connected!',
                      style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 10),
                  Text('Code: $connectedDeviceCode',
                      style: theme.textTheme.bodyMedium),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Image.asset('assets/images/icons/Offline.png',
                      width: 200, height: 200),
                  const SizedBox(height: 20),
                  Text('Device is not connected',
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(color: AppColor.errorColor)),
                  Text('Scan QR and connect device',
                      style: theme.textTheme.bodyMedium),
                  const SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () => _showScanner(context),
                    child: CircleAvatar(
                      backgroundColor: Colors.blueAccent.withOpacity(0.7),
                      radius: 45,
                      child: Image.asset(
                          width: 60, 'assets/images/icons/qr-code-scan.png'),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
      ),
    );
  }
}
