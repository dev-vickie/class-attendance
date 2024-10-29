import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DiscoveryPage extends StatefulWidget {
  @override
  _DiscoveryPageState createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  List<BluetoothDiscoveryResult> results = [];
  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _startDiscovery();
  }

  void _startDiscovery() {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((result) {
      setState(() {
        results.add(result);
      });
    });

    _streamSubscription!.onDone(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discovery')),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (BuildContext context, index) {
          BluetoothDiscoveryResult result = results[index];
          return ListTile(
            title: Text(result.device.name ?? "Unknown device"),
            subtitle: Text(result.device.address),
            onTap: () {
              Navigator.of(context).pop(result.device);
            },
          );
        },
      ),
    );
  }
}
