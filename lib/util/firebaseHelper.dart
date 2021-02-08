import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/model/todo.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseHelper {
  static final FirebaseHelper _firebaseHelper = FirebaseHelper._internal();

  final databaseReference = FirebaseFirestore.instance;
  // // 1
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('todos');
  // 2
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  FirebaseHelper._internal();

  factory FirebaseHelper() {
    return _firebaseHelper;
  }

  Future<FirebaseApp> initializeFirebase() async {
    return Firebase.initializeApp();
  }

  // 3
  // Future<DocumentReference> addPet(Pet pet) {
  //   return collection.add(pet.toJson());
  // }

  // // 4
  // updatePet(Pet pet) async {
  //   await collection
  //       .document(pet.reference.documentID)
  //       .updateData(pet.toJson());
  // }
}
