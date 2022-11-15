import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class FireStorageState extends GetxController {
  String _folderPath = "";
  String get folderPath => _folderPath;

  List<Reference> _files = [];
  List<Reference> get files => _files;

  List<Reference> _folders = [];
  List<Reference> get folders => _folders;

  List<UploadingFile> uploadingFiles = [];

  Future<void> getListOfFiles(String path) async {
    List<Reference> tempFiles = [];
    final storageRef = FirebaseStorage.instance.ref(path);
    final listResult = await storageRef.listAll();
    for (var item in listResult.items) {
      tempFiles.add(item);
    }
    _files = tempFiles;
  }

  void pathsetter(String path) {
    _folderPath = path;
  }

  Future<void> deleteDirectory(String path) async {
    final storageRef = FirebaseStorage.instance.ref(path);
    final listResult = await storageRef.listAll();
    for (var item in listResult.items) {
      //tempFiless.add(item);
      await item.delete();
      _files.remove(item);
    }
    for (var prefix in listResult.prefixes) {
      print(prefix);
      await prefix.delete();
      _files.remove(prefix);
      //tempFiless.add(prefix);
      deleteDirectory(prefix.fullPath);
    }
  }

  Future<void> getListOfFolders(String path) async {
    List<Reference> tempFolders = [];
    final storageRef = FirebaseStorage.instance.ref(path);
    final listResult = await storageRef.listAll();
    for (var prefix in listResult.prefixes) {
      tempFolders.add(prefix);
    }

    _folders = tempFolders;
  }

  Future<void> getDirection(String path) async {
    await getListOfFiles(path);
    await getListOfFolders(path);
    update();
  }

  Future<File?> downloadAnyFile(
      Reference ref, BuildContext context, bool message) async {
    //final url = await ref.getDownloadURL();

    String name = ref.name;
    String url = await ref.getDownloadURL();

    try {
      final appStorage = await getApplicationDocumentsDirectory();
      //final file = File('${appStorage.path}/${ref.name}');
      final file = File('${'/storage/emulated/0/Download'}/$name');
      final response = await Dio().get(url,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              receiveTimeout: 0));
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      if (message) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(ref.name + " downloaded succesfully.")));
      }

      return file;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future openFile(Reference ref, BuildContext context) async {
    final file = await downloadAnyFile(ref, context, false);
    if (file == null) {
      return;
    }
    OpenFile.open(file.path);
  }

  Future<void> deleteFile(String path, BuildContext context) async {
    print(path);
    final storageRef = FirebaseStorage.instance.ref();
    final deleteRef = storageRef.child(path);
    await deleteRef.delete();
    _files.remove(deleteRef);

    update();
    try {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(path.split("/").last + " deleted succesfully.")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(path + " deleted succesfully.")));
    }
  }

  Future<void> uploadFile(File file) async {
    String filePath = _folderPath != ""
        ? "$_folderPath/${getFileName(file)}"
        : getFileName(file);
    print("filepath:$filePath");
    UploadTask task = FirebaseStorage.instance.ref(filePath).putFile(file);
    UploadingFile uploadingFileState = Get.put(
        UploadingFile(percent: 0, task: TaskState.running, path: filePath),
        tag: filePath);
    uploadingFiles.add(uploadingFileState);
    update();
    task.snapshotEvents.listen((taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          uploadingFileState.setPercent =
              taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
          break;
        case TaskState.paused:
          // ...
          uploadingFileState.setTask = TaskState.paused;
          break;
        case TaskState.success:
          GetInstance().delete<UploadingFile>(tag: filePath);
          uploadingFiles.remove(uploadingFileState);
          _files.add(taskSnapshot.ref);
          await insertSecurityFileToSubDirs(_folderPath);
          update();
          break;
        case TaskState.canceled:
          GetInstance().delete<UploadingFile>(tag: filePath);
          uploadingFiles.remove(uploadingFileState);
          update();
          break;
        case TaskState.error:
          GetInstance().delete<UploadingFile>(tag: filePath);
          uploadingFiles.remove(uploadingFileState);
          update();
          break;
      }
    });
  }

  String getFileName(File file) {
    return file.path.split("/").last;
  }

  Future<void> insertSecurityFileToSubDirs(String path) async {
    List<String> paths = path.split("/");
    await FirebaseStorage.instance.ref("$path/.txt").putData(Uint8List(0));
    paths.removeLast();
    if (paths.isNotEmpty) {
      insertSecurityFileToSubDirs(paths.join("/"));
    }
  }
  //Future<void> saveToGallery(Reference ref, BuildContext context) async {
  //  final url = await ref.getDownloadURL();
  //  final tempDir = await getTemporaryDirectory();
  //  final path = '${tempDir.path}/${ref.name}';
  //  await Dio().download(url, path);
  //  await GallerySaver.saveImage(path, toDcim: true);
  //  ScaffoldMessenger.of(context).showSnackBar(
  //      SnackBar(content: Text(ref.name + " downloaded succesfully.")));
  //}
}

class UploadingFile extends GetxController {
  double percent;
  TaskState task;
  String path;
  UploadingFile({
    required this.percent,
    required this.task,
    required this.path,
  });

  set setPercent(double percent) {
    this.percent = percent;
    update();
  }

  set setTask(TaskState task) {
    this.task = task;
    update();
  }

  String get name => path.split("/").last;

  @override
  void dispose() {
    super.dispose();
  }
}
