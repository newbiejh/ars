import 'dart:convert';

import 'package:ars/components/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HistoryCheckPage extends StatefulWidget {
  const HistoryCheckPage({Key? key}) : super(key: key);

  @override
  State<HistoryCheckPage> createState() => _HistoryCheckPageState();
}

class _HistoryCheckPageState extends State<HistoryCheckPage> {
  var itemList = [];
  var itemnames = [];
  var data;
  var priceinfo = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      data =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      setState(() {});
      getItemPrice();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _replaceShowroomURL(itemList);
  }

  Future<void> getItemPrice() async {
    if (mounted) {
      setState(() {
        itemList = data?['data'];
        _updateShowroomURL(itemList);
      });
    }
    for (var item in itemList) {
      String name = item['name'];
      itemnames.add(name);
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
                '${data!['title']} 조회',
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
                                    '${data!['data'][index]['icon']}',
                                    '${data!['data'][index]['part']}');
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
            onPressed: () => Navigator.pushNamed(context, '/history'),
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

void _replaceShowroomURL(var itemList) {
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
      showroom_url = showroom_url.replaceAll('$key:$replaceValue', '$key:null');
    }
  }
}
