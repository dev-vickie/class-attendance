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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text('Select bonded device')),
      body: FutureBuilder(
          future: FlutterBluetoothSerial.instance.getBondedDevices(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            return ListView.builder(
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
            );
          }),
    );
  }
}
