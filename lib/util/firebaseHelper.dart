import 'package:flutter/material.dart';
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

  Future deleteTodo(String id) async {
    return databaseReference.runTransaction((Transaction myTransaction) async {
      myTransaction.delete(collection.doc(id));
      debugPrint("Todo with id: " + id + " was deleted");
    });
  }

  Future insertTodo(Todo todo) async {
    return databaseReference.runTransaction((Transaction myTransaction) async {
      myTransaction.set(collection.doc(), todo.toMap());
      debugPrint("Todo with id: " + collection.doc().id + " was inserted");
    });
  }

  Future updateTodo(Todo todo) async {
    return databaseReference.runTransaction((Transaction myTransaction) async {
      myTransaction.update(collection.doc(todo.id), todo.toMap());
      debugPrint("Todo with id: " + todo.id + " was updated");
    });
  }
}
