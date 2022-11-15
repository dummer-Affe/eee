import 'package:firebase_storage/firebase_storage.dart';
import '/main.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'alert_dialog.dart';
import '../home_page/file_action_alertdialog.dart';

class FileView extends StatelessWidget {
  FileView({super.key, required this.file});
  Reference file;

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
      child: GestureDetector(
        onLongPress: () {
          actionsDialog(context, file);
        },
        onTap: () async {
          //var status = await Permission.storage.status;
          //        if (!status.isGranted) {
          //          await Permission.storage.request();
          //        }
          
          await storageState.openFile(file, context);
          
        },
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Icon(
                  Icons.file_present_rounded,
                  color: Colors.grey,
                  size: 60,
                ),
              ),
              Text(
                file.name,
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
