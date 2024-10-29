import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class RecordedNamesPage extends StatelessWidget {
  final List<String> recordedNames;

  const RecordedNamesPage({Key? key, required this.recordedNames})
      : super(key: key);

  Future<void> _saveAndShareFile(BuildContext context) async {
    try {
      // Get the directory to save the file
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/qualified_students.txt';

      // Create the file and write the recorded names
      final file = File(filePath);
      await file.writeAsString(recordedNames.join('\n'));

      // Share the file
      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'List of Qualified Students',
      );
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save and share the file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Center(
            child: Text(
          'QUALIFIED STUDENTS',
          style: TextStyle(fontSize: 20, color: Colors.blueGrey),
        )),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: recordedNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(recordedNames[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () => _saveAndShareFile(context),
              icon: Icon(Icons.download),
              label: Text('Download'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
            ),
          ),
        ],
      ),
    );
  }
}
