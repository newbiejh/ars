import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ars/pages/login_page.dart';
import 'init.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      debugShowCheckedModeBanner: false,
      // 테마설정
      theme: ThemeData(
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: Size(400, 60))),
      ),

      initialRoute: "/init",
      routes: {
        "/login": (context) => LoginPage(),
        "/init": (context) => Init()
      },
    );
  }
}