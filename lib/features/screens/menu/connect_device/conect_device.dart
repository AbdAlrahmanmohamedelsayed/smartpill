import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:permission_handler/permission_handler.dart';

class ConnectDevice extends StatefulWidget {
  const ConnectDevice({super.key});

  @override
  State<ConnectDevice> createState() => _ConnectDeviceState();
}

class _ConnectDeviceState extends State<ConnectDevice> {
  bool isDeviceConnected = false;
  bool isConnecting = false;
  String connectionStatus = "Checking connection...";
  final MobileScannerController _scannerController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    _requestPermissions().then((_) => _checkInitialConnection());
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    if (await Permission.location.request().isGranted) {
      // Permission granted
    } else {
      _showSnackBar('Location permission denied. Cannot connect to WiFi.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _checkInitialConnection() async {
    try {
      var currentWifi = await WiFiForIoTPlugin.getSSID();
      if (currentWifi == "ESP32_Hotspot") {
        setState(() {
          isDeviceConnected = true;
          connectionStatus = "Connected to ESP32";
        });
      } else {
        setState(() {
          isDeviceConnected = false;
          connectionStatus = "Not connected to ESP32";
        });
      }
    } catch (e) {
      setState(() {
        isDeviceConnected = false;
        connectionStatus = "Error checking connection: $e";
      });
      _showSnackBar('Error checking connection: $e');
    }
  }

  Future<void> _disconnectFromESP32() async {
    try {
      await WiFiForIoTPlugin.disconnect();
      setState(() {
        isDeviceConnected = false;
        connectionStatus = "Disconnected from ESP32";
      });
      _showSnackBar('Disconnected from ESP32');
    } catch (e) {
      _showSnackBar('Error disconnecting: $e');
    }
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
            controller: _scannerController,
            onDetect: (BarcodeCapture capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                Navigator.pop(context);
                _connectToESP32();
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

  Future<void> _connectToESP32() async {
    if (isConnecting) return;

    setState(() {
      isConnecting = true;
      connectionStatus = "Connecting to ESP32...";
    });

    try {
      // Check if WiFi is enabled
      bool isWifiEnabled = await WiFiForIoTPlugin.isEnabled();
      if (!isWifiEnabled) {
        await WiFiForIoTPlugin.setEnabled(true);
        throw Exception('WiFi was disabled. Please try again.');
      }

      // Attempt to connect to ESP32 hotspot
      bool connected = await WiFiForIoTPlugin.connect(
        "ESP32_Hotspot",
        password: "12345678",
        joinOnce: true,
        security: NetworkSecurity.WPA,
      );

      if (!connected) {
        throw Exception('Failed to connect to ESP32');
      }

      // Wait for stable connection
      await Future.delayed(const Duration(seconds: 10));

      // Verify connection
      var currentWifi = await WiFiForIoTPlugin.getSSID();
      if (currentWifi != "ESP32_Hotspot") {
        throw Exception(
            'Could not verify ESP32 connection. Current WiFi: $currentWifi');
      }

      setState(() {
        isDeviceConnected = true;
        connectionStatus = "Connected to ESP32!";
      });
      _showSnackBar('ESP32 connected!');
    } catch (e) {
      String errorMessage = e.toString();
      setState(() {
        connectionStatus = "Connection failed: $errorMessage";
        isDeviceConnected = false;
      });
      _showSnackBar('Error: $errorMessage');
      print('Connection error: $errorMessage');
    } finally {
      setState(() {
        isConnecting = false;
      });
    }
  }

  Widget _buildConnectedUI(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(width: 170, 'assets/images/logo.png'),
        const SizedBox(height: 20),
        Text('Connected to ESP32!', style: theme.textTheme.bodyLarge),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              backgroundColor: theme.primaryColor,
              padding: EdgeInsets.all(12)),
          onPressed: _disconnectFromESP32,
          child: Text(
            'Disconnect',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: AppColor.whiteColor),
          ),
        ),
      ],
    );
  }

  Widget _buildDisconnectedUI(ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 40),
          Image.asset('assets/images/icons/Offline.png',
              width: 200, height: 200),
          const SizedBox(height: 20),
          if (isConnecting)
            Column(
              children: [
                CircularProgressIndicator(color: AppColor.primaryColor),
                const SizedBox(height: 10),
              ],
            ),
          Text(
            connectionStatus,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isConnecting ? AppColor.primaryColor : AppColor.errorColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Scan QR to connect to ESP32',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: isConnecting ? null : () => _showScanner(context),
            child: CircleAvatar(
              backgroundColor:
                  AppColor.primaryColor.withOpacity(isConnecting ? 0.3 : 0.7),
              radius: 45,
              child: Image.asset(
                width: 60,
                'assets/images/icons/qr-code-scan.png',
              ),
            ),
          ),
          const SizedBox(height: 40),
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
        title: const Text('Connect to ESP32'),
        leading: const BackButton(color: AppColor.whiteColor),
      ),
      body: Center(
        child: isDeviceConnected
            ? _buildConnectedUI(theme)
            : _buildDisconnectedUI(theme),
      ),
    );
  }
}
