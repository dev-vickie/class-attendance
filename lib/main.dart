import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trial/firebase_options.dart';
import 'package:trial/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  void initState() {
    super.initState();
    openBoxes();
  }

  void openBoxes() async {
    await Hive.openBox<String>('nameBox');
    final box = Hive.box<String>('nameBox');
    box.get('key'); // Ensure this key exists and data is retrieved

    // Open other boxes as needed
  }

  // void saveData() async {
  //   final box = Hive.box<String>('nameBox');
  //   await box.put('key', 'value');
  // }

  // void loadData() {
  //   final box = Hive.box<String>('nameBox');
  //   // ignore: unused_local_variable
  //   final value = box.get('key');

  //   // Use the retrieved value
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SignInScreen(),
    );
  }
}
