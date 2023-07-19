import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yeni_deneme/login_page.dart';
import 'package:yeni_deneme/services/auth_service.dart';


class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

TextEditingController _emailTextcontroller = TextEditingController();

class _ForgetPasswordState extends State<ForgetPassword> {
  final formKey = GlobalKey<FormState>();
  final authService = AuthService();

  @override
  void dispose() {
    _emailTextcontroller.dispose();
    super.dispose();
  }

  void forget_pass() async {
    if (_emailTextcontroller.text.isEmpty ||
        !_emailTextcontroller.text.contains("@")) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('HATA'),
            content: Text("Lütfen Geçerli bir mail adresi yazınız"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Geri Dön'),
              ),
            ],
          );
        },
      );
    } else {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
            email: _emailTextcontroller.text.toLowerCase());
             Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage(),),);
      } on FirebaseAuthException catch (e) {
        print("$e");
       
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ŞİFREMİ UNUTTUM'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 172, 22, 198),
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      'https://i.pinimg.com/236x/08/ea/b2/08eab2d11f44042ee413939fb2067cd0.jpg'),
                  fit: BoxFit.cover),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 50),
                  ),
                  const Text(
                    'Şifremi Unuttum',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailTextcontroller,
                    decoration: InputDecoration(
                      hintText: 'E-mail',
                      //focus olunca rengi
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 172, 22, 198),
                        ),
                      ),
                      //normal haldeki rengi
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      forget_pass();
                    },
                    child: Text(
                      'Şifremi Yenile',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
