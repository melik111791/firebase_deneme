import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:yeni_deneme/forget_password_page.dart';
import 'package:yeni_deneme/home_page.dart';
import 'package:yeni_deneme/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController forgetPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late String email, password;
  final firebaseAuth = FirebaseAuth.instance;
  final authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('KAYIT EKRANI'),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 50),
                  ),
                  const Text(
                    'GİRİŞ YAPIN',
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
                      } else if (!value.contains("@gmail.com")) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('HATA'),
                              content: Text(
                                  "Lütfen Geçerli bir mail adresi yazınız"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Geri Dön'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {}
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

                  //GİRİŞ YAPICAĞIMIZ 2. TEXTFİELD ALANININ  GÖRÜNÜMÜNÜ AYARLADIK(şifre)
                  TextFormField(
                    controller: forgetPasswordController,
                    //Boş olup olmadığını kontrol ediyoruz
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Bilgileri eksiksiz doldurun";
                      } else {}
                      if (value.length < 6) {
                        return "En az 6 haneli bir şifre girin ";
                      } else {}
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
                  //Şifremi unuttum kısmı
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => ForgetPassword()),
                          ),
                        );
                      },
                      child: const Text(
                        'Şifremi Unuttum',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  //Giriş yap kısmını yaptık
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          final result =
                              await authService.signIn(email, password);
                          if (result == "success") {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                                (route) => false);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('HATA'),
                                  content: Text(result!),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Geri Dön'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          try {
                            final userResult =
                                await firebaseAuth.signInWithEmailAndPassword(
                                    email: email, password: password);
                            Navigator.pushNamed(context, "/homePage");
                            print(userResult.user!.email);
                          } catch (e) {
                            print(e.toString());
                          }
                        } else {}
                      },
                      child: Container(
                        height: 50,
                        width: 120,
                        margin: const EdgeInsets.symmetric(horizontal: 60),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.lerp(Colors.orange, Colors.yellow, 4),
                        ),
                        child: const Center(
                          child: Text(
                            'Giriş Yap',
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  //Hesap oluşturkısmını yaptık
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, "/signUp"),
                      child: const Text(
                        'Hesap Oluştur',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  //Misafir girişi butonu yaptık
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 101, 43, 62)),
                      onPressed: () async {
                        final result = await authService.signInAnonymus();
                        if (result != null) {
                          Navigator.pushNamed(context, "/homePage");
                        } else {
                          print("Hata ile karşılaşıldı");
                        }
                      },
                      label: Text(
                        'Misafir girişi',
                      ),
                      icon: Icon(
                        Icons.person,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  //Google ile giriş kısmını yaptık
                  Center(
                      child: IconButton(
                    icon: Image.network(
                        'https://img.freepik.com/free-icon/google_318-278809.jpg'),
                    iconSize: 40,
                    onPressed: () {
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
                      provider.googleLogin().then((value) => Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage())));
                    },
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
