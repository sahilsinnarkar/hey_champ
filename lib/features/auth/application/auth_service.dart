import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

ValueNotifier<AuthServices> authServices = ValueNotifier(AuthServices());

class AuthServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> signin({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signup({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  Future<void> resetPassword({
    required String email,
  }) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUserName({
    required String username,
  }) async {
    if (currentUser != null) {
      await currentUser!.updateDisplayName(username);
      await currentUser!.reload();
    }
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    if (currentUser != null) {
      await currentUser!.reauthenticateWithCredential(credential);
      await currentUser!.delete();
      await firebaseAuth.signOut();
    }
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    if (currentUser != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: currentUser!.email!,
        password: currentPassword,
      );
      await currentUser!.reauthenticateWithCredential(credential);
      await currentUser!.updatePassword(newPassword);
    }
  }
}