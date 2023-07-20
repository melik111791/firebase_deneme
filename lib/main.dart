import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:yeni_deneme/home_page.dart';
import 'package:yeni_deneme/login_page.dart';
import 'package:yeni_deneme/services/auth_service.dart';
import 'package:yeni_deneme/sign_up.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,

          //sayfalar arası geçiş
          routes: {
            "/loginPage": (context) =>
                LoginPage(), //artık /loginPage çağırıldığında LogionPage()'e gidicek!
            "/signUp": (context) =>
                SignUp(), // artık /signUp çağırıldığında SignUp()'a gidicek!
            "/homePage": (context) =>
                HomePage(), // artık /homePage çağırıldığında HomePage()'e gidicek!
          },
          title: 'Login Firebase App',

          home: LoginPage(),
        ),
      );
}
