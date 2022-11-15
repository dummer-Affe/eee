import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../functions/getFileList.dart';
import '../main.dart';

class FolderView extends StatelessWidget {
  FolderView({super.key, required this.folder, required this.currentpath});
  Reference folder;
  String currentpath;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.3,
      height: height * 0.15,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        border: Border.all(
            color: Colors.grey, // Set border color
            width: 1.0), // Set border width
        borderRadius: const BorderRadius.all(
            Radius.circular(10.0)), // Set rounded corner radius
        //boxShadow: [
        //  BoxShadow(blurRadius: 10, color: Colors.black, offset: Offset(1, 3))
        //] // Make rounded corner of border
      ),
      child: TextButton(
        onPressed: () async {
          //print(storageState.folderPath);
          await storageState.deleteDirectory(currentpath);
          //storageState.pathsetter(currentpath);
          //await storageState.getDirection(currentpath);
        },
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Icon(
                  Icons.folder,
                  color: Colors.grey,
                  size: 60,
                ),
              ),
              Text(
                folder.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
