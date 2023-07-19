import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yeni_deneme/home_page.dart';
import 'package:yeni_deneme/services/auth_service.dart';
import 'package:yeni_deneme/widgets/customtxt_button.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  late String email, password, fullname, username;
  final firebaseAuth = FirebaseAuth.instance;
  final authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KAYIT EKRANI'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 172, 22, 198),
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      'https://i.pinimg.com/236x/08/ea/b2/08eab2d11f44042ee413939fb2067cd0.jpg'),
                  fit: BoxFit.cover),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                  ),
                  const Text(
                    'KAYIT OLUN',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontStyle: FontStyle.italic),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  //GİRİŞ YAPICAĞIMIZ 1. TEXTFİELD ALANININ  GÖRÜNÜMÜNÜ AYARLADIK(mail)
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Bilgileri eksiksiz doldurun";
                      } else if (!value.contains("@")) {
                        return "Lütfen Geçerli bir mail adresi yazınız";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      email = value!;
                    },
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

                  //GİRİŞ YAPICAĞIMIZ 2. TEXTFİELD ALANININ  GÖRÜNÜMÜNÜ AYARLADIK(ad-soyad)
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Bilgileri eksiksiz doldurun";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      fullname = value!;
                    },
                    decoration: InputDecoration(
                      hintText: 'Ad-Soyad',
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

                  //GİRİŞ YAPICAĞIMIZ 3. TEXTFİELD ALANININ  GÖRÜNÜMÜNÜ AYARLADIK(kullanıcı adı)
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Bilgileri eksiksiz doldurun";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      username = value!;
                    },
                    decoration: InputDecoration(
                      hintText: 'Kullanıcı Adı',
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

                  //GİRİŞ YAPICAĞIMIZ 4. TEXTFİELD ALANININ  GÖRÜNÜMÜNÜ AYARLADIK(şifre)
                  TextFormField(
                    //Boş olup olmadığını kontrol ediyoruz
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Bilgileri eksiksiz doldurun";
                      } else {}
                      if (value.length < 6) {
                        return "En az 6 haneli bir şifre girin ";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      password = value!;
                    },
                    obscureText:
                        true, //Şifre yazılırken gözükmemesini sağlamak için

                    decoration: InputDecoration(
                      hintText: 'Şifre',
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

                  //Hesap oluştur kısmını yaptık
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          final result = await authService.SignUp(
                              email: email,
                              password: password,
                              username: username,
                              fullname: fullname,
                              context: context);
                          try {
                            if (result != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Profil başarıyla oluşturuldu!'),
                                ),
                              );
                              Navigator.pushNamed(context, "/loginPage");
                            }
                          } catch (e) {
                            print("$e");
                          }
                        }
                      },
                      child: const Text(
                        'Hesap Oluştur',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  //geri dönme butonu
                  Center(
                    child: TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, "/loginPage"),
                      child: const Text(
                        'Giriş Sayfasına Geri Dön ',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
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
