import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import '../states/files_folders_state.dart';
import '/main.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'alert_dialog.dart';
import '../home_page/file_action_alertdialog.dart';

class UploadingFileWidget extends StatelessWidget {
  UploadingFileWidget({super.key, required this.file});
  UploadingFile file;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final line = width * 0.3 - 40;
    return GetBuilder<UploadingFile>(
        tag: file.path,
        builder: (controller) {
          return Container(
            width: width * 0.3,
            height: height * 0.15,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey[800]!,
              border: Border.all(
                  color: Colors.grey, // Set border color
                  width: 1.0), // Set border width
              borderRadius: const BorderRadius.all(
                  Radius.circular(10.0)), // Set rounded corner radius
              //boxShadow: [
              //  BoxShadow(blurRadius: 10, color: Colors.black, offset: Offset(1, 3))
              //] // Make rounded corner of border
            ),
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
                  Container(
                    width: line+3,
                    height: 10,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(children: [
                      Container(
                          width: line * file.percent,
                          height: 10,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20))),
                      if (file.percent != 1) Spacer()
                    ]),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
