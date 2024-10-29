import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trial/nametracker.dart';

class UnitTrackerPage extends StatefulWidget {
  static String? latestPageTitle; // Static field to store the latest page title
  static List<String> enteredTexts = [];

  @override
  _UnitTrackerPageState createState() => _UnitTrackerPageState();
}

class _UnitTrackerPageState extends State<UnitTrackerPage> {
  TextEditingController unitTitleController = TextEditingController();
  late Box<String> box;
  late List<String> enteredTexts;

  @override
  void initState() {
    super.initState();
    openBox();
    enteredTexts = []; // Initialize here if necessary
  }

  Future<void> openBox() async {
    box = await Hive.openBox<String>('nameBox');
    enteredTexts = box.values.toList();
    setState(() {});
  }

  Future<void> saveAndNavigate(String pageTitle) async {
    if (pageTitle.isNotEmpty) {
      await box.put('latestPageTitle', pageTitle);

      enteredTexts.add(pageTitle);
      unitTitleController.clear();
      setState(() {});
      UnitTrackerPage.latestPageTitle = pageTitle; // Store the page title
      navigateToNameTrackerPage(pageTitle);
    }
  }

  void navigateToNameTrackerPage(String pageTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NameTracker(
          appBarTitle: pageTitle,
          boxTitles: enteredTexts,
          boxTitle: '',
          hiveboxTitle: '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Center(
          child: Text(
            'CLASS UNITS',
            style: TextStyle(fontSize: 20, color: Colors.blueGrey),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: unitTitleController,
              decoration: InputDecoration(
                hintText: 'Enter Page Title',
              ),
              onSubmitted: (value) async {
                await saveAndNavigate(value.trim());
              },
            ),
            SizedBox(height: 20),
            enteredTexts.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: enteredTexts.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            navigateToNameTrackerPage(enteredTexts[index]);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              enteredTexts[index],
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : SizedBox(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await saveAndNavigate(unitTitleController.text.trim());
              },
              child: Text('Enter'),
            ),
          ],
        ),
      ),
    );
  }
}
