// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class SelectBondedDevicePage extends StatefulWidget {
  final bool checkAvailability;

  const SelectBondedDevicePage({required this.checkAvailability});

  @override
  _SelectBondedDevicePageState createState() => _SelectBondedDevicePageState();
}

class _SelectBondedDevicePageState extends State<SelectBondedDevicePage> {
  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();
    _getBondedDevices();
  }

  void _getBondedDevices() async {
    devices = await FlutterBluetoothSerial.instance.getBondedDevices();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select bonded device')),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (BuildContext context, index) {
          BluetoothDevice device = devices[index];
          return ListTile(
            title: Text(device.name ?? "Unknown device"),
            subtitle: Text(device.address),
            onTap: () {
              Navigator.of(context).pop(device);
            },
          );
        },
      ),
    );
  }
}
