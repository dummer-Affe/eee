import '/widgets/uploading_file.dart';
import '/widgets/folder_view_widget.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import '../main.dart';
import '../states/files_folders_state.dart';
import '../widgets/file_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchText = TextEditingController();

  List<Reference> files = [];
  List<Reference> folders = [];
  @override
  void initState() {
    storageState.getDirection("");

    super.initState();
  }

  List<Widget> getview(String testament) {
    List<Widget> filesFolders = [];
    for (var folder in storageState.folders) {
      if (folder.name.contains(testament) || testament == "") {
        filesFolders.add(FolderView(
          currentpath: folder.fullPath,
          folder: folder,
        ));
      }
    }

    for (var file in storageState.files) {
      if (file.name.contains(testament) || testament == "") {
        filesFolders.add(FileView(
          file: file,
        ));
      }
    }
    for (var file in storageState.uploadingFiles) {
      if (file.name.contains(testament) || testament == "") {
        filesFolders.add(UploadingFileWidget(file: file));
      }
    }
    return filesFolders;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GetBuilder<FireStorageState>(builder: ((controller) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 45.0, left: 30, right: 30),
            child: SizedBox(
                height: height * 0.07,
                child: TextField(
                  style: TextStyle(color: Colors.grey[400]),
                  controller: searchText,
                  onChanged: (letters) {
                    setState(() {});
                  },
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[700],
                      suffixIcon: TextButton(
                          onPressed: () {},
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://c4.wallpaperflare.com/wallpaper/483/975/648/anime-kaguya-sama-love-is-war-chika-fujiwara-hd-wallpaper-preview.jpg"),
                          )),
                      contentPadding: EdgeInsets.only(
                        top: height * 0.07 / 10, // HERE THE IMPORTANT PART
                      ),
                      hintText: "Search In Drive",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: TextButton(
                          onPressed: () {},
                          child: Icon(
                            Icons.menu,
                            color: Colors.grey[400],
                          )),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(45)))),
                )),
          ),
          SizedBox(
              width: width,
              height: height * 0.78,
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 20,
                mainAxisSpacing: 5,
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                children: <Widget>[
                  for (var wid in getview(searchText.text)) wid
                ],
              )),
        ],
      );
    }));
  }
}
