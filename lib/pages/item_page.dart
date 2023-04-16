import 'package:ars/components/url.dart';
import 'package:flutter/material.dart';

class ItemPage extends StatelessWidget {
  const ItemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                _showBackDialog(context);
              },
              icon: Icon(Icons.arrow_back),
              color: Colors.black),
          title: Text(
            '아바타 생성 결과 조회',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.yellow,
          foregroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Image.network(
                    showroomtest_url,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Row(
                    children: [
                      Container(
                        child: Image.network(
                          itemtest_url,
                          width: 28,
                          height: 28,
                        ),
                      ),
                      Container(
                        child: Image.network(
                          itemtest_url,
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  TextButton(onPressed: () {}, child: Text("위젯 배치 테스트")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// 뒤로가기 다이얼로그 출력
Future<dynamic> _showBackDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          '뒤로가기',
          textAlign: TextAlign.center,
        ),
        content: Text('이전 화면으로 돌아가시겠습니까? 현재 내용이 사라집니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/image'),
            child: Text('예'),
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('아니오'),
          ),
        ],
      );
    },
  );
}
