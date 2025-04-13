import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:smartpill/core/theme/color_pallets.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:wifi_iot/wifi_iot.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'dart:io';

class ConnectDevice extends StatefulWidget {
  const ConnectDevice({super.key});

  @override
  State<ConnectDevice> createState() => _ConnectDeviceState();
}

class _ConnectDeviceState extends State<ConnectDevice> {
  bool isDeviceConnected = false;
  String? connectedDeviceCode;
  String connectionStatus = "Not connected";
  bool isConnecting = false;

  final NetworkInfo _networkInfo = NetworkInfo();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final MobileScannerController _scannerController = MobileScannerController();

  String? _userWifiName;
  String? _userWifiPassword;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _saveCurrentWifiDetails();
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.locationWhenInUse,
      Permission.nearbyWifiDevices,
      Permission.camera,
    ].request();

    // Check permission status and show appropriate messages
    if (statuses[Permission.locationWhenInUse]!.isDenied) {
      _showSnackBar('Location permission is required for WiFi operations');
    }

    if (statuses[Permission.nearbyWifiDevices]!.isDenied) {
      _showSnackBar('Nearby WiFi devices permission denied');
    }

    if (statuses[Permission.camera]!.isDenied) {
      _showSnackBar('Camera permission is required for QR scanning');
    }
  }

  Future<void> _saveCurrentWifiDetails() async {
    try {
      _userWifiName = await _networkInfo.getWifiName();
      if (_userWifiName != null) {
        // Remove quotes if present
        _userWifiName = _userWifiName!.replaceAll('"', '');
        // Store network name for future use
        await _secureStorage.write(key: 'last_wifi_ssid', value: _userWifiName);

        // Note: In the actual case, we cannot get the WiFi password
        // We will ask the user to enter it later when needed
      }
    } catch (e) {
      _showSnackBar('Error getting WiFi information: $e');
    }
  }

  Future<void> _getStoredWifiPassword() async {
    try {
      // Try to retrieve previously stored password
      _userWifiPassword =
          await _secureStorage.read(key: 'wifi_password_${_userWifiName}');

      // If password is not stored, ask user to enter it
      if (_userWifiPassword == null) {
        await _showPasswordDialog();
      }
    } catch (e) {
      _showSnackBar('Error retrieving password: $e');
    }
  }

  Future<void> _showPasswordDialog() async {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController ssidController = TextEditingController();

    if (_userWifiName != null) {
      ssidController.text = _userWifiName!;
    }

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          'Enter WiFi Information',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ssidController,
              decoration: const InputDecoration(
                labelText: 'Network Name (SSID)',
                hintText: 'Enter WiFi network name',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter WiFi password',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _userWifiName = ssidController.text;
              _userWifiPassword = passwordController.text;

              // Store information for future use
              _secureStorage.write(key: 'last_wifi_ssid', value: _userWifiName);
              _secureStorage.write(
                  key: 'wifi_password_${_userWifiName}',
                  value: _userWifiPassword);

              Navigator.pop(context);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _connectToESPHotspot(String ssid, {String? password}) async {
    setState(() {
      isConnecting = true;
      connectionStatus = "Connecting to device hotspot...";
    });

    try {
      bool connected = false;

      // Use wifi_iot to connect to ESP network (Android only)
      if (Platform.isAndroid) {
        // Check if WiFi is enabled
        if (!(await WiFiForIoTPlugin.isEnabled())) {
          await WiFiForIoTPlugin.setEnabled(true);
        }

        // Connect to ESP Hotspot
        if (password != null) {
          connected = await WiFiForIoTPlugin.connect(ssid,
              password: password, security: NetworkSecurity.WPA);
        } else {
          // Try to connect to open network
          connected = await WiFiForIoTPlugin.connect(ssid);
        }
      } else {
        // On iOS, ask user to connect manually
        _showSnackBar(
            'Please connect to the device network manually from WiFi settings: $ssid');
        // Wait to give user time to connect
        await Future.delayed(const Duration(seconds: 10));

        // Check connection
        final connectivityResult = await Connectivity().checkConnectivity();
        final currentWifi = await _networkInfo.getWifiName();

        connected = connectivityResult == ConnectivityResult.wifi &&
            currentWifi != null &&
            currentWifi.contains(ssid);
      }

      if (connected) {
        setState(() {
          connectionStatus = "Connected to device hotspot!";
        });
        await _sendWifiCredentials();
      } else {
        throw Exception("Failed to connect to device hotspot");
      }
    } catch (e) {
      setState(() {
        isConnecting = false;
        connectionStatus = "Connection failed: ${e.toString()}";
      });
      _showSnackBar(
          'Failed to connect to device hotspot. Please try again or connect manually.');
    }
  }

  Future<void> _sendWifiCredentials() async {
    setState(() {
      connectionStatus = "Sending WiFi credentials...";
    });

    try {
      // Get user's WiFi credentials if not already available
      if (_userWifiPassword == null) {
        await _getStoredWifiPassword();
      }

      if (_userWifiName == null || _userWifiPassword == null) {
        throw Exception("Failed to get WiFi credentials");
      }

      // Send credentials to ESP
      final encodedSsid = Uri.encodeComponent(_userWifiName!);
      final encodedPassword = Uri.encodeComponent(_userWifiPassword!);

      final response = await http
          .get(
            Uri.parse(
                'http://192.168.4.1/setwifi?ssid=$encodedSsid&password=$encodedPassword'),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        setState(() {
          isDeviceConnected = true;
          connectedDeviceCode = _userWifiName;
          isConnecting = false;
          connectionStatus = "Device successfully configured!";
        });

        // Return to original WiFi network (Android only)
        if (Platform.isAndroid) {
          await WiFiForIoTPlugin.disconnect();
          // Reconnecting to original network can be problematic as correct password might not be available
          _showSnackBar('Please reconnect to your WiFi network.');
        }
      } else {
        throw Exception("Failed to send WiFi credentials");
      }
    } catch (e) {
      setState(() {
        isConnecting = false;
        connectionStatus = "Failed to send credentials: ${e.toString()}";
      });

      _showSnackBar('Error: ${e.toString()}');
    }
  }

  void _processQRCode(String code) {
    // Check if the code is a valid ESP Hotspot connection string
    if (code.startsWith('WIFI:')) {
      // Extract SSID and password from QR code
      // Format: WIFI:S:<SSID>;T:<WPA|WEP|>;P:<password>;;
      final RegExp ssidRegex = RegExp(r'S:(.*?);');
      final RegExp passRegex = RegExp(r'P:(.*?);');

      final ssidMatch = ssidRegex.firstMatch(code);
      final passMatch = passRegex.firstMatch(code);

      if (ssidMatch != null && ssidMatch.groupCount >= 1) {
        final String ssid = ssidMatch.group(1)!;
        final String? password = passMatch?.group(1);

        _connectToESPHotspot(ssid, password: password);
      } else {
        _showErrorMessage('Invalid QR code format');
      }
    } else if (code.contains('192.168.4.1')) {
      // It's already the ESP URL, try to parse and use it
      try {
        final uri = Uri.parse(code);
        final String? ssid = uri.queryParameters['ssid'];
        final String? password = uri.queryParameters['password'];

        if (ssid != null) {
          // Store information provided by QR
          if (password != null) {
            _secureStorage.write(key: 'wifi_password_$ssid', value: password);
          }

          // Connect to ESP Hotspot (use generic ESP name as actual name is unknown)
          _connectToESPHotspot("ESP32_SmartPill", password: "12345678");
        } else {
          _showErrorMessage('Invalid ESP URL format');
        }
      } catch (e) {
        _showErrorMessage('Invalid ESP URL: ${e.toString()}');
      }
    } else {
      _showErrorMessage('Unrecognized QR code format');
    }
  }

  void _showErrorMessage(String message) {
    _showSnackBar(message);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
            controller: _scannerController,
            onDetect: (BarcodeCapture capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                String scannedCode = barcodes.first.rawValue!;
                Navigator.pop(context);
                _processQRCode(scannedCode);
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

  void _manualConnect() async {
    // Use this function to provide a manual connection method if QR scanning fails
    await _showPasswordDialog();
    if (_userWifiName != null && _userWifiPassword != null) {
      _connectToESPHotspot("ESP32_SmartPill", password: "12345678");
    }
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
                  Text('Connected to: $connectedDeviceCode',
                      style: theme.textTheme.bodyMedium),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 40),
                  Image.asset('assets/images/icons/Offline.png',
                      width: 200, height: 200),
                  const SizedBox(height: 20),
                  if (isConnecting)
                    CircularProgressIndicator(
                      color: AppColor.primaryColor,
                    ),
                  const SizedBox(height: 10),
                  Text(connectionStatus,
                      style: theme.textTheme.bodyLarge?.copyWith(
                          color: isConnecting
                              ? AppColor.primaryColor
                              : AppColor.errorColor)),
                  Text('Scan QR and connect device',
                      style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap:
                            isConnecting ? null : () => _showScanner(context),
                        child: CircleAvatar(
                          backgroundColor: Colors.blueAccent
                              .withOpacity(isConnecting ? 0.3 : 0.7),
                          radius: 45,
                          child: Image.asset(
                              width: 60,
                              'assets/images/icons/qr-code-scan.png'),
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: isConnecting ? null : () => _manualConnect(),
                        child: CircleAvatar(
                          backgroundColor: Colors.greenAccent
                              .withOpacity(isConnecting ? 0.3 : 0.7),
                          radius: 45,
                          child: const Icon(Icons.wifi,
                              size: 40, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  TextButton(
                    onPressed: isConnecting ? null : () => _manualConnect(),
                    child: Text(
                      'Connect Manually',
                      style: TextStyle(
                        color:
                            isConnecting ? Colors.grey : AppColor.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }
}
