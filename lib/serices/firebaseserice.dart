import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseSerice {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirebaseSerice();

  Future<bool> loginUser(
      {required String email, required String password}) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    if (userCredential.user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> registerUser({
    required String email,
    required String password,
    required String name,
    required File image,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      String userid = userCredential.user!.uid;
      String filename = Timestamp.now().millisecondsSinceEpoch.toString() +
          p.extension(image.path);
      UploadTask task =
          _storage.ref('/images/$userid/$filename').putFile(image);
      return task.then((snapshot) async {
        String downloadurl = await snapshot.ref.getDownloadURL();
        await _db.collection('users').doc(userid).set({
          'name': name,
          'email': email,
          'imagepath': downloadurl,
        });
        return true;
      });
    } catch (e) {
      return false;
    }
  }

  Future<bool> uploadpost(File image) {
    String userid = _auth.currentUser!.uid;
    String filename = Timestamp.now().millisecondsSinceEpoch.toString() +
        p.extension(image.path);
    UploadTask task = _storage.ref('/posts/$userid/$filename').putFile(image);
    return task.then(
      (snapshot) async {
        String downloadurl = await snapshot.ref.getDownloadURL();
        _db.collection('posts').add(
          {
            'timestamp': Timestamp.now,
            'image': downloadurl,
            'uid': userid,
          },
        );
        return true;
      },
    );
  }
}
