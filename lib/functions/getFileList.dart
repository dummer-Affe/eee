//import 'package:firebase_storage/firebase_storage.dart';
//
//class FireStorageFuncs {
//
//  Future<List<Reference>> getListOfFiles(String path) async {
//    final storageRef = FirebaseStorage.instance.ref(path);
//    final listResult = await storageRef.listAll();
//    print(listResult.items);
//    return listResult.items;
//  }
//
//  Future<List<Reference>> getListOfFolders(String path) async {
//    final storageRef = FirebaseStorage.instance.ref(path);
//    final listResult = await storageRef.listAll();
//    print(listResult.prefixes);
//    return listResult.prefixes;
//  }
//}
