import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:trial/nametracker.dart';
import 'package:trial/unitTracker.dart';

import 'DiscoveryPage.dart';

import 'SelectBondedDevicePage.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  @override
  void initState() {
    super.initState();
    _initializeBluetooth();
  }

  Future<void> _initializeBluetooth() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;
    setState(() {});

    FlutterBluetoothSerial.instance.onStateChanged().listen((state) {
      setState(() => _bluetoothState = state);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bluetooth Chat')),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: const Text('Enable Bluetooth'),
            value: _bluetoothState.isEnabled,
            onChanged: (bool value) async {
              if (value) {
                await FlutterBluetoothSerial.instance.requestEnable();
              } else {
                await FlutterBluetoothSerial.instance.requestDisable();
              }
              setState(() {});
            },
          ),
          ListTile(
            title: const Text('Explore discovered devices'),
            onTap: () async {
              final BluetoothDevice? selectedDevice =
                  await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => DiscoveryPage()),
              );

              if (selectedDevice != null) {
                String pageTitle =
                    UnitTrackerPage.latestPageTitle ?? 'Default Title';
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NameTracker(
                      server: selectedDevice,
                      appBarTitle: pageTitle,
                      boxTitle: '',
                      hiveboxTitle: '',
                      boxTitles: UnitTrackerPage.enteredTexts,
                    ),
                  ),
                );
              }
            },
          ),
          ListTile(
            title: const Text('Connect to paired device to chat'),
            onTap: () async {
              final BluetoothDevice? selectedDevice =
                  await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        SelectBondedDevicePage(checkAvailability: false)),
              );

              if (selectedDevice != null) {
                String pageTitle =
                    UnitTrackerPage.latestPageTitle ?? 'Default Title';
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NameTracker(
                      server: selectedDevice,
                      appBarTitle: pageTitle,
                      boxTitle: '',
                      hiveboxTitle: '',
                      boxTitles: UnitTrackerPage.enteredTexts,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
// TODO Implement this library.