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
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(3, (rowIndex) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(3, (colIndex) {
                                int index = rowIndex * 3 + colIndex;
                                return _showItemSmallIcon(
                                    '${testData[index]['icon']}',
                                    '${testData[index]['part']}');
                              }),
                            );
                          }),
                        ),
                      ),
                      //_showItemSmallIcon('${testData[9]['icon']}', '${testData[9]['part']}') 무기 아이콘
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    // 스크롤 방향을 세로로 지정
                    itemCount: testData.length,
                    // 아이템 총 개수는 10개, 무기 제외하면 9개
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: _showItemInfoBox(
                                '${testData[index]['icon']}',
                                '${testData[index]['name']}',
                                '500')),
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

SingleChildScrollView _showItemInfoBox(
    String itemicon, String itemname, String price) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Image.network(
              "${item_icon_url}${itemicon}",
              width: 28,
              height: 28,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                // 이미지 로딩 중 에러가 발생하면 error.png 이미지 반환
                return Image.asset(
                  'assets/images/error.PNG',
                  width: 28,
                  height: 28,
                );
              },
            ),
          ),
        ),
        Text(itemname),
        SizedBox(
          width: 50,
        ),
        Text('가격 : ${price}')
      ],
    ),
  );
}

Column _showItemSmallIcon(String icon, String part) {
  return Column(
    children: [
      Container(
          child: Image.network(
            '${item_icon_url}${icon}',
            width: 28,
            height: 28,
          )),
      Text(
        '${part}',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      )
    ],
  );
}
