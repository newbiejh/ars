// 로그인 정보가 이미 있는지 확인하고, 없으면 로그인 페이지, 있으면 홈페이지로 연결하는 라우터 페이지

import 'package:ars/pages/image_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Init extends StatelessWidget {
  const Init({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("firebase load fail"),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return ImagePage();
        }
        return CircularProgressIndicator();
      },
    );
  }
}
