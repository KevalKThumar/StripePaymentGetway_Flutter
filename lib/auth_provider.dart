// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prectical_exam/home.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  User get user => _auth.currentUser!;

  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      showSnackBar(context, 'Account created successfully');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
        (route) => route.isFirst,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
      showSnackBar(context, e.message!);
    }
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
        (route) => route.isFirst,
      );

      showSnackBar(context, 'Login successful');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }
}

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
