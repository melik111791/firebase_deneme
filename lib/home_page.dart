import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:yeni_deneme/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? eposta;
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      setState(() {
        eposta = value.data()?['email'];
      });
    });// bi hata alıyoruz ama
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Center(
              child: Text("Anasayfa"),
            ),
            SizedBox(
              height: 100,
            ),
            Text('eposta adresınız $eposta '),
            ElevatedButton.icon(
                style: ButtonStyle(),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                icon: Icon(Icons.arrow_back_ios_new),
                label: Text('Geri dön'),)
          ],
        ),
      ),
    );
}
}

