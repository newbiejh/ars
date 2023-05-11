// 메인 페이지 구성 Scaffold

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/url.dart';
import 'login_page.dart';
import 'package:image_picker/image_picker.dart';

class ImagePage extends StatelessWidget {
  const ImagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.data != null) {
            return WillPopScope(
                child: Scaffold(
                    appBar: AppBar(
                      iconTheme: IconThemeData(
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                    ),
                    // 사이드 메뉴
                    drawer: _showDrawer(context, snapshot),
                    body: ListView(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        TextButton(
                          onPressed: () async {
                            var picker = ImagePicker();
                            var image = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (image != null) {
                              print("###########3"); // TODO: 마지막에 제거
                              String fileName = image.path.split('/').last;
                              FormData formData = FormData.fromMap({
                                "files": await MultipartFile.fromFile(
                                    image.path,
                                    filename: fileName),
                              });
                              var response = await Dio().post(
                                upload_url,
                                data: formData,
                              );
                              print("@@@@@@${response.statusCode}"); // TODO: 마지막에 제거
                            }
                          },
                          child: Text("아바타 이미지 업로드"),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/item');
                            },
                            child: Text("아이템 출력 페이지 테스트용"))
                      ],
                    )),
                onWillPop: () async => false); // TODO: 뒤로가기 버튼 누를 시 종료 다이얼로그 출력
          } else
            return LoginPage();
        });
  }

  // 사이드 메뉴 출력 함수
  Drawer _showDrawer(BuildContext context, AsyncSnapshot<User?> snapshot) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.home, color: Colors.black),
            title: Text('내 정보'),
            onTap: () {
              _showUserInfo(context, snapshot);
            },
            trailing: Icon(Icons.arrow_forward),
          ),
          ListTile(
            leading: Icon(Icons.history, color: Colors.black),
            title: Text('아바타 저장 기록'),
            onTap: () {
              Navigator.pushNamed(context, '/history');
            },
            trailing: Icon(Icons.arrow_forward),
          ),
          ListTile(
              leading: Icon(Icons.logout, color: Colors.black),
              title: Text('로그아웃'),
              onTap: () {
                _showLogoutCheck(context, snapshot);
              }),
        ],
      ),
    );
  }

  // 로그아웃 클릭시 예, 아니오 다이얼로그 출력
  Future<dynamic> _showLogoutCheck(
      BuildContext context, AsyncSnapshot<User?> snapshot) {
    return showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              //Dialog Main Title
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("로그아웃 하시겠습니까?"),
                ],
              ),
              //
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                    },
                    child: Text("예"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("아니오"),
                  ),
                ],
              ),
            ),
          );
        });
  }

  // 내 정보를 팝업으로 출력할 함수
  Future<dynamic> _showUserInfo(
      BuildContext context, AsyncSnapshot<User?> snapshot) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            //Dialog Main Title
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("이름: ${snapshot.data!.displayName}"),
                Text(
                  '이메일: ${snapshot.data!.email}',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("닫기"),
                ),
              ],
            ),
          );
        });
  }
}
