import 'dart:convert';

import 'package:ars/components/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// TODO: 저장 기능 추가

class ItemPage extends StatefulWidget {
  const ItemPage({Key? key}) : super(key: key);

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  TextEditingController _titleController = TextEditingController();
  var itemList = [];
  var email;
  var emailFromRoute;
  var itemnames = [];
  var priceinfo = [];
  http.Client? _client; // http.Client 객체 저장 변수
  bool isFetching = false; // 상태 변수 추가

  @override
  void initState() {
    super.initState();
    // Future.microtask를 사용하여 build 메소드 이후에 ModalRoute의 값을 가져옴
    Future.microtask(() async {
      emailFromRoute = ModalRoute.of(context)?.settings.arguments.toString();
      setState(() {
        email = emailFromRoute ?? '';
      });
      fetchData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _client?.close(); // http.Client 객체 닫기
    showroom_url =
        "https://avatarsync.df.nexon.com/wear/image/stand@2x.png?wearInfo=%7B%22job%22:%224%22,%22level%22:0,%22hair%22:null,%22cap%22:null,%22face%22:null,%22neck%22:null,%22coat%22:null,%22belt%22:null,%22pants%22:null,%22shoes%22:null,%22skin%22:null,%22weapon1%22:null,%22package%22:null,%22animation%22:%22Stand%22%7D";
  }

  void fetchData() {
    if (!isFetching) {
      // 중복 호출 방지
      isFetching = true; // 실행 중 상태로 변경
      fetchItemWithRetry().then((_) {
        isFetching = false; // 완료 후 상태 변경
      });
    }
  }

  Future<void> fetchItemWithRetry() async {
    const maxRetryCount = 10;
    const retryDelay = Duration(seconds: 15);
    var retryCount = 0;
    var isStatusCode200 = false;

    while (retryCount < maxRetryCount && !isStatusCode200) {
      final response = await http.get(Uri.parse(avatar_info_get_url + email));
      print('아바타 생성 statusCode : ${response.statusCode}');

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
        for (var item in itemList) {
          String name = item['name'];
          itemnames.add(name);
        }
      }

      retryCount++;
      if (!isStatusCode200) {
        await Future.delayed(retryDelay);
      }
    }

    if (!isStatusCode200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              '오류',
              textAlign: TextAlign.center,
            ),
            content: Text(
              '아바타 생성 중 오류가 발생했습니다.',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    }

    for (var item in itemnames) {
      final response =
          await http.get(Uri.parse('$price_url_front$item$price_url_end'));

      final jsonData = json.decode(response.body);
      final jsonLength = jsonData['rows'].length;

      if (jsonLength != 0) {
        final price = jsonData['rows'][0]['price'];
        final formattedPrice =
            NumberFormat('#,##0').format(price); // 세 자리마다 ','를 추가하여 형식화
        priceinfo.add("$formattedPrice골드");
      } else {
        priceinfo.add("최근 1개월 내 거래 없음");
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (itemList.isNotEmpty && priceinfo.isNotEmpty) {
      // data 배열 비어있을 때 빨간 오류창 방지하기 위해 if문 삽입
      return Scrollbar(
        thickness: 4.0,
        radius: Radius.circular(8.0),
        child: WillPopScope(
          onWillPop: () async {
            _showBackDialog(context);
            return false;
          },
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
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppBar(
                                      backgroundColor: Colors.yellow,
                                      leading: IconButton(
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      title: Text(
                                        '자세히 보기',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Image.network(
                                      showroom_url,
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Image.network(
                          showroom_url,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
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
                            '${priceinfo[index]}',
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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('생성 중입니다...'),
              SizedBox(height: 16),
              Text('최대 5분...'),
            ],
          ),
        ),
        backgroundColor: Colors.white,
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
        content: Text(
          '이전 화면으로 돌아가시겠습니까? 현재 내용이 사라집니다.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
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

Future<dynamic> _showSaveDialog(var itemList, BuildContext context,
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
                  _saveAvatarToServer(itemList, context, title, email);
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
    var itemList, BuildContext context, String title, String email) async {
  try {
    final url = Uri.parse(avatar_save_url);

    // POST 요청을 보냅니다.
    Map<String, dynamic> requestBody = {
      "data": itemList,
      "title": title.toString(),
      "email": email.toString(),
    };

    print(jsonEncode(requestBody));

    final response = await http.post(
      url,
      body: jsonEncode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode ~/ 100 == 2) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.pop(context); // 다이얼로그 닫기
          });

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
    } else {
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
  } catch (error) {
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(itemname),
            SizedBox(
              height: 5,
            ),
            Text('가격 : ${price}'),
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
