import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Muzeler/Profile/picture_service.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  StorageService _storageService = StorageService();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String MediaUrl = "";
  int a = 0;

  Future<User?> singIn(String email, String password) async {
    try {
      var user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return user.user;
    } catch (e) {
      print(e.toString());
    }
  }

  singOut() async {
    return await _auth.signOut();
  }

  Future<User?> SignUp(String name, String email, String password) async {
    try {
      var user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firestore.collection("Person").doc(user.user!.uid).set(
          {"userName": name, "email": email, "image": MediaUrl, "müze": []});

      return user.user;
    } catch (e) {
      print(e);
    }
  }

  CurrentUser() {
    return _auth.currentUser;
  }

  CurrentUserId() {
    return _auth.currentUser!.uid;
  }

  UploadMedia(XFile pickedFile) async {
    bool succ = true;
    try {
      MediaUrl = await _storageService.uploadMedia(File(pickedFile.path));
      _firestore
          .collection("Person")
          .doc(_auth.currentUser!.uid)
          .update({"image": MediaUrl});
      return MediaUrl;
    } catch (e) {
      succ = false;
      return succ;
    }
  }

  UpdateUserName(String name) async {
    return await _firestore
        .collection("Person")
        .doc(_auth.currentUser!.uid)
        .update({"userName": name});
  }

  UpdatePassword(String mail) async {
    return await _auth.sendPasswordResetEmail(email: mail);
  }

  FavMuseum(String muzaAd, String muzaResim) async {
    _firestore.collection("Person").doc(_auth.currentUser!.uid).update({
      "müze": FieldValue.arrayUnion([
        {"ad": muzaAd, "resim": muzaResim}
      ]),
    });
    /*return await _firestore
        .collection("Person")
        .doc(_auth.currentUser!.uid)
        .collection(muzaAd)
        .doc(_auth.currentUser!.uid)
        .set({"müzeAd": muzaAd, "müzeResim": muzaResim});*/
  }

  DeleteFavMuseum(List muzeler) async {
    _firestore.collection("Person").doc(_auth.currentUser!.uid).update({
      "müze": muzeler,
    });
  }

  Stream GetFavMuseum(String muzeAd) {
    return _firestore
        .collection("Person")
        .doc(_auth.currentUser!.uid)
        .snapshots();
  }

/*
  Future<DataTutuyoz> getPerson(String id) async {
    var snap = await _firestore.collection("Person").doc(id).get();
    return DataTutuyoz.fromMap(snap.data);
  }*/
}
