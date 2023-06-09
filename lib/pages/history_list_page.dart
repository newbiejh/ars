// 아바타 저장 기록 리스트 확인 페이지

import 'dart:convert';

import 'package:ars/components/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  var history = [];
  var email;
  var emailFromRoute;

  @override
  void initState() {
    super.initState();
    // Future.microtask를 사용하여 build 메소드 이후에 ModalRoute의 값을 가져옴
    Future.microtask(() async {
      emailFromRoute = ModalRoute.of(context)?.settings.arguments.toString();
      setState(() {
        email = emailFromRoute ?? '';
      });
      fetchHistory();
    });
  }

  Future fetchHistory() async {
    final response = await http.get(Uri.parse('${history_check_url}/$email'));
    print('저장 내역 statusCode : ${response.statusCode}');

    var list = [];
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      list = jsonDecode(responseBody);
      print('#############$list');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              '오류',
              textAlign: TextAlign.center,
            ),
            content: Text(
              '저장 기록을 불러오는 중 오류가 발생했습니다.',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    }
    if (mounted) {
      setState(() {
        history = list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (history.isNotEmpty) {
      // data 배열 비어있을 때 빨간 오류창 방지하기 위해 if문 삽입
      return Scrollbar(
        thickness: 4.0,
        radius: Radius.circular(8.0),
        child: WillPopScope(
          onWillPop: () async {
            Navigator.pushNamed(context, '/image');
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                  color: Colors.black),
              title: Text(
                '아바타 저장 기록 조회',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.yellow,
              foregroundColor: Colors.black,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    // 스크롤 방향을 세로로 지정
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                              height: 40,
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/check',
                                      arguments:
                                          history[index]['id'].toString());
                                },
                                child: Container(
                                  height: 40,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text('${history[index]['email']}'),
                                ),
                              )));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('저장 기록 생성 중...'),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    ); // data에 값 없으면 진행 중 마크 표시
  }
}

// TODO: 저장 기록 GET
