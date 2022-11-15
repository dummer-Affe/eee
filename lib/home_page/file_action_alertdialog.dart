import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../main.dart';
import '../widgets/alert_dialog.dart';
import 'package:flutter/services.dart';

class FileActionAlertDialog extends StatefulWidget {
  FileActionAlertDialog({super.key, required this.file});
  Reference file;

  @override
  State<FileActionAlertDialog> createState() => _FileActionAlertDialogState();
}

class _FileActionAlertDialogState extends State<FileActionAlertDialog> {
  String generatedLink = "";
  bool showLink = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(children: [
        TextButton(
          onPressed: () async {
            await storageState.downloadAnyFile(widget.file, context, true);
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.download,
                color: Colors.grey,
              ),
              Text("Download", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
        ),
        TextButton(
          onPressed: () async {
            await storageState.deleteFile(widget.file.fullPath, context);
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              Text("Delete", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
        ),
        TextButton(
          onPressed: () async {
            await storageState.openFile(widget.file, context);
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.open_in_new,
                color: Colors.grey,
              ),
              Text("View", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
        ),
        TextButton(
          onPressed: () async {
            generatedLink = await widget.file.getDownloadURL();
            setState(() {
              showLink = true;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.link,
                color: Colors.grey,
              ),
              Text("Generate a Link",
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        showLink
            ? TextButton(
                onPressed: () async {
                  Clipboard.setData(ClipboardData(text: generatedLink))
                      .then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Generated address copied to clipboard")));
                  });
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: width / 2,
                      child: Text(
                        generatedLink,
                        style: TextStyle(overflow: TextOverflow.ellipsis,color: Colors.grey[400]),
                      ),
                    ),
                    Icon(Icons.copy,color: Colors.grey[400]),
                  ],
                ))
            : SizedBox(),
      ]),
    );
  }
}

actionsDialog(BuildContext context, reference) {
  myDialog(
      bgColor: Colors.grey[800],
      child: FileActionAlertDialog(
        file: reference,
      ),
      context: context);
}
