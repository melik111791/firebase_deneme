

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yeni_deneme/login_page.dart';
import 'package:yeni_deneme/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthService {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  Future signInAnonymus() async {
    try {
      final result = await firebaseAuth.signInAnonymously();
      print(result.user!.uid);
      return result.user;
    } catch (e) {
      print("Anonymus error $e");
      return null;
    }
  }

  Future<String?> signIn(String email, String password) async {
    String? res;
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      res = "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        //firebase'nin kendine özgü hata errorlarından biri bu: user-not-found
        res = "Kullanıcı Bulunamadı";
      } else if (e.code == "wrong-password") {
        //firebase'nin kendine özgü hata errorlarından biri bu: wrong-password
        res = "Şifre Yanlış";
      } else if (e.code == "user-disabled") {
        //firebase'nin kendine özgü hata errorlarından biri bu: user-disabled
        res = "Kullanıcı Bloke Olmuş";
      } else {}
    }
    return res;
  }

  Future<User?> SignUp(
      {required String email,
      required String password,
      required String username,
      required String fullname,
      required BuildContext context}) async {
    User? user;
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
      try {
        final resultData = await firebaseFirestore.collection("Users").add({
          "email": email,
          "fullname": fullname,
          "username": username,
          "post": [],
          "followers": [],
          "following": [],
          "bio": "",
          "website": "",
        });
      } catch (e) {
        print("$e");
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Mail zaten kayıtlı'),
                            ),
                          );
          break;
        case "ERROR-INVALID-EMAIL":
        case "İnvalid-email":
          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Geçersiz mail'),
                            ),
                          );
          break;
        default:
         ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Bir hata ile karşılaşıldı, bir süre sonra tekrar deneyiniz!'),
                            ),
                          );
          break;
      }
    }
    return user;
  }
}
