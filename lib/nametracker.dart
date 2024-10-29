import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:hive/hive.dart';
import 'package:trial/bluetooth.dart';
import 'package:trial/namerow.dart';
import 'package:trial/recorded_names_page.dart';
import 'package:trial/unitTracker.dart';

class NameTracker extends StatefulWidget {
  final BluetoothDevice? server;
  final String appBarTitle;
  final String boxTitle;
  final List boxTitles;

  NameTracker({
    required this.appBarTitle,
    required this.boxTitle,
    required this.boxTitles,
    this.server,
    required String hiveboxTitle,
  });

  @override
  _NameTrackerState createState() => _NameTrackerState();
}

class _NameTrackerState extends State<NameTracker> {
  BluetoothConnection? connection;
  List<String> names = [];
  Map<String, Map<int, DateTime>> nameOccurrences = {};
  Map<String, DateTime> lastCheckTimes = {};
  List<String> recordedNames = [];

  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _loadData().then((_) => _connect());
  }

  @override
  void dispose() {
    connection?.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      if (!Hive.isBoxOpen(widget.boxTitle)) {
        await Hive.openBox(widget.boxTitle);
      } else {
        print('Box ${widget.boxTitle} is already open');
      }

      Box<Map<String, dynamic>> nameBox =
          Hive.box<Map<String, dynamic>>(widget.boxTitle);

      final rawData = nameBox.get('data');
      print('Raw data loaded: $rawData');

      if (rawData != null) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(rawData);

        // Parsing logic remains the same...

        print('Data successfully loaded and parsed: $data');
      } else {
        print('No data found for key "data"');
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> _connect() async {
    if (widget.server == null) return;
    try {
      connection = await BluetoothConnection.toAddress(widget.server!.address);
      connection!.input!.listen((data) {
        setState(() {
          addName(utf8.decode(data));
        });
      }).onDone(() {
        print('Disconnected by remote');
      });
    } catch (e) {
      print('Cannot connect, exception occurred: $e');
    }
  }

  void addName(String name) {
    setState(() {
      if (!names.contains(name)) {
        names.add(name);
        nameOccurrences[name] = {};
        lastCheckTimes[name] = DateTime.now();
        nameOccurrences[name]![8] = DateTime.now();
      } else {
        final currentTime = DateTime.now();
        final lastCheckedTime =
            lastCheckTimes[name] ?? DateTime.fromMillisecondsSinceEpoch(0);

        if (currentTime.difference(lastCheckedTime) >= Duration(seconds: 1)) {
          final lastCheckedWeek = nameOccurrences[name]!.keys.last;
          if (lastCheckedWeek < 104) {
            nameOccurrences[name]![lastCheckedWeek + 8] = currentTime;
            if (lastCheckedWeek == 64 && !recordedNames.contains(name)) {
              recordedNames.add(name);
            }
          }
          lastCheckTimes[name] = currentTime;
        }
      }
      _saveData();
    });
  }

  void handleCheckboxTap(String name, int percentage) {
    if (!names.contains(name)) return;

    if (percentage == 72 && !recordedNames.contains(name)) {
      setState(() {
        recordedNames.add(name);
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecordedNamesPage(recordedNames: recordedNames),
        ),
      );
    }

    final currentTime = DateTime.now();
    final lastCheckedTime =
        lastCheckTimes[name] ?? DateTime.fromMillisecondsSinceEpoch(0);

    if (currentTime.difference(lastCheckedTime) >= Duration(seconds: 1)) {
      setState(() {
        nameOccurrences[name]![percentage] =
            nameOccurrences[name]![percentage] ?? currentTime;
        lastCheckTimes[name] = currentTime;
      });
      _saveData();
    }
  }

  void _saveData() async {
    try {
      if (!Hive.isBoxOpen(widget.boxTitle)) {
        print('Opening box: ${widget.boxTitle}');
        await Hive.openBox(widget.boxTitle);
      } else {
        print('Box ${widget.boxTitle} is already open');
      }

      Box<Map<String, dynamic>> nameBox =
          Hive.box<Map<String, dynamic>>(widget.boxTitle);

      final dataToSave = {
        'names': names,
        'nameOccurrences': nameOccurrences,
        'lastCheckTimes': lastCheckTimes,
        'recordedNames': recordedNames,
      };

      await nameBox.put('data', dataToSave);
      final savedata = nameBox.get("data");
      print("savedata = $savedata");
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Center(
          child: Text(
            widget.appBarTitle,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.blueGrey),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.blueGrey),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) =>
                        MainPage()))); // Go back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RecordedNamesPage(recordedNames: recordedNames),
                  ),
                );
              },
              child: Text('Qualified Students'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: names.length,
                itemBuilder: (context, index) {
                  final name = names[index];
                  return NameRow(
                    name: name,
                    nameOccurrences: nameOccurrences[name] ?? {},
                    onCheckboxTapped: (percentage) =>
                        handleCheckboxTap(name, percentage),
                    onCheckboxTap: (percentage) {},
                  );
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => UnitTrackerPage())));
        },
        child: Text('Save'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
