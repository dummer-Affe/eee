import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'home_page/homePage.dart';
import 'states/files_folders_state.dart';

late FireStorageState storageState;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  storageState = Get.put(FireStorageState());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        storageState.getDirection("");
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.grey[600],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Starred',
            backgroundColor: Colors.grey[600],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Shared',
            backgroundColor: Colors.grey[600],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Folders',
            backgroundColor: Colors.grey[600],
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
      ),
      backgroundColor: Colors.grey[800],
      floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.blue[800],
          onPressed: () async {
            uploadFile();
          },
          child: Icon(Icons.add)),
      body: HomePage(),
    );
  }

  uploadFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      for (var file in files) {
        storageState.uploadFile(file);
      }
    }
  }
}
