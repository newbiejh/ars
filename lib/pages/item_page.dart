import 'dart:convert';

import 'package:ars/components/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ItemPage extends StatefulWidget {
  const ItemPage({Key? key}) : super(key: key);

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  var data = [];

  @override
  void initState() {
    super.initState();
    fetchItem();
  }

  Future fetchItem() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/comments'));

    var list = [];
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      list = jsonDecode(responseBody);
    } else {
      throw Exception('Failed to load Item');
    }
    if (this.mounted) {
      setState(() {
        data = list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data.isNotEmpty) {
      // data 배열 비어있을 때 빨간 오류창 방지하기 위해 if문 삽입
      return Scrollbar(
        thickness: 4.0,
        radius: Radius.circular(8.0),
        child: WillPopScope(
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
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    // 스크롤 방향을 세로로 지정
                    itemCount: data.length,
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
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Image.network(
                                        itemtest_url,
                                        width: 28,
                                        height: 28,
                                      ),
                                    ),
                                  ),
                                  Text('${data[index]['email']}'),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Text('가격 : ${data[index]['id'].toString()}')
                                ],
                              ),
                            )),
                      );
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
            Text('생성 중입니다...'),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    ); // data에 값 없으면 진행 중 마크 표시
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
