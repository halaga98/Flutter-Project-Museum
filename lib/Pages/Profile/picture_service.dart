import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

//resim eklemek için
  Future<String> uploadMedia(File file) async {
    var uploadTask = await _firebaseStorage
        .ref()
        .child(
            "${DateTime.now().millisecondsSinceEpoch}.${file.path.split('.').last}")
        .putFile(file);

    var storageRef = await uploadTask;

    return await storageRef.ref.getDownloadURL();
  }

  deleteImage(String url) async {
    return await _firebaseStorage.refFromURL(url).delete();
  }
}
