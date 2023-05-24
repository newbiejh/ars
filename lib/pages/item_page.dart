import 'dart:convert';

import 'package:ars/components/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// TODO: 저장 버튼 및 기능 추가
// TODO: 가격 api 연결

class ItemPage extends StatefulWidget {
  const ItemPage({Key? key}) : super(key: key);

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  TextEditingController _titleController = TextEditingController();
  var itemList = [];

  @override
  void initState() {
    super.initState();
    fetchItemWithRetry();
  }

  Future<void> fetchItemWithRetry() async {
    const maxRetryCount = 5;
    const retryDelay = Duration(seconds: 5);
    var retryCount = 0;
    var isStatusCode200 = false;

    while (retryCount < maxRetryCount && !isStatusCode200) {
      final response = await http.get(Uri.parse(avatar_info_get_url));
      print(response.statusCode);

      if (response.statusCode == 200) {
        isStatusCode200 = true;
        String responseBody = utf8.decode(response.bodyBytes);
        var list = jsonDecode(responseBody);

        if (mounted) {
          setState(() {
            itemList = list;
            _updateShowroomURL(itemList);
          });
        }
      }

      retryCount++;
      await Future.delayed(retryDelay);
    }

    if (!isStatusCode200) {
      throw Exception('Failed to load Item');
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments.toString();

    if (itemList.isNotEmpty) {
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
                color: Colors.black,
              ),
              title: Text(
                '아바타 생성 결과 조회',
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    _showSaveDialog(itemList, context, _titleController, email);
                  },
                  icon: Icon(Icons.save),
                  color: Colors.black,
                ),
              ],
              backgroundColor: Colors.yellow,
              foregroundColor: Colors.black,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.network(
                        showroom_url,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(2, (rowIndex) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(4, (colIndex) {
                                int index = rowIndex * 4 + colIndex;
                                return _showItemSmallIcon(
                                  '${itemList[index]['icon']}',
                                  '${itemList[index]['part']}',
                                );
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
                    itemCount: itemList.length,
                    // 아이템 총 개수는 10개, 무기 제외하면 9개
                    itemBuilder: (context, index) {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 16),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: _showItemInfoBox(
                            '${itemList[index]['icon']}',
                            '${itemList[index]['name']}',
                            //'${item_price[index]}',
                          ),
                        ),
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

Future<dynamic> _showSaveDialog(var data, BuildContext context,
    TextEditingController titleController, String email) {
  return showDialog(
    context: context,
    builder: (
      BuildContext context,
    ) {
      return AlertDialog(
        title: Text(
          '아바타 저장',
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '현재 아바타를 저장하시겠습니까?',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: '저장할 아바타 이름',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  String title = titleController.text;
                  _saveAvatarToServer(data, context, title, email);
                },
                child: Text('예'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('아니오'),
              ),
            ],
          ),
        ],
      );
    },
  );
}

Future<void> _saveAvatarToServer(
    var data, BuildContext context, String title, String email) async {
  try {
    final url = Uri.parse(avatar_save_url);

    // POST 요청을 보냅니다.
    Map<String, dynamic> requestBody = {
      //'data': data,
      'title': title.toString(),
      'email': email.toString(),
    };

    print(requestBody);

    final response = await http.post(
      url,
      body: jsonEncode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );
    print("!!!!!!!!!!!${response.statusCode}");
    if (response.statusCode~/100 == 2) {
      // 저장이 완료되었을 때 알림을 표시합니다.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              '저장 완료',
              textAlign: TextAlign.center,
            ),
            content: Text(
              '아바타가 성공적으로 저장되었습니다.',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    }
  } catch (error) {
    // 저장 실패 시 오류 메시지를 표시합니다.
    print("에러#############");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '저장 실패',
            textAlign: TextAlign.center,
          ),
          content: Text(
            '아바타 저장 중 오류가 발생했습니다.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}

SingleChildScrollView _showItemInfoBox(
  String itemicon,
  String itemname,
  /*String price*/
) {
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(itemname),
            SizedBox(
              height: 5,
            ),
            //Text('가격 : ${price}'),
          ],
        )
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

void _updateShowroomURL(var itemList) {
  Map<String, String> partMap = {
    '머리': '%22hair%22',
    '모자': '%22cap%22',
    '얼굴': '%22face%22',
    '목가슴': '%22neck%22',
    '상의': '%22coat%22',
    '허리': '%22belt%22',
    '하의': '%22pants%22',
    '신발': '%22shoes%22',
  };

  for (int index = 0; index < itemList.length; index++) {
    String part = itemList[index]['part'];
    String? key = partMap[part];

    if (key != null) {
      String replaceValue =
          '%7B%22index%22:%22${itemList[index]['index']}%22,%20%22color%22:0%7D';
      showroom_url = showroom_url.replaceAll('$key:null', '$key:$replaceValue');
    }
  }
}
