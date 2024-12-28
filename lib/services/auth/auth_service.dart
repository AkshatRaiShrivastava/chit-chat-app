import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  //instance of Auth and firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get current user
  User? getCurrentUser(){
    return _auth.currentUser;
  }

  //signin
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign out
  Future<void> signout() async {
    return await _auth.signOut();
  }

  //signup with email and password
  Future<UserCredential> signupWithEmailPAssword(String email, password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid' : userCredential.user!.uid,
        'email' : email
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
}
