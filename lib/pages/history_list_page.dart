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
  var useremail;
  var emailFromRoute;
  var history = [];
  var save_list_length;

  String jsonString = '[{"data":[{"part":"머리","icon":"pr_ahair/00001.png","name":"스포츠컷[A타입]","index":"0u13"},{"part":"모자","icon":"pr_acap/00111.png","name":"홀리아머 투구[D타입]","index":"neww7i"},{"part":"얼굴","icon":"pr_aface/00193.png","name":"보석 둠 마스크[A타입]","index":"qfjv7i"},{"part":"목가슴","icon":"pr_aneck/00106.png","name":"만진의 망토","index":"w42r7i"},{"part":"상의","icon":"pr_acoat/00124.png","name":"백호의 가죽상의","index":"84sr7i"},{"part":"허리","icon":"pr_abelt/00148.png","name":"화랑의 노리개 요갑[D타입]","index":"unaw7i"},{"part":"하의","icon":"pr_apants/00127.png","name":"표범무늬 수영 팬츠[B타입]","index":"6a7r7i"},{"part":"신발","icon":"pr_ashoes/00061.png","name":"무반의 사냥신[A타입]","index":"tfcw7i"}],"title":"TestDate2","email":"test1@naver.com"},{"data":[{"part":"머리","icon":"pr_ahair/00132.png","name":"짧은 군인 머리[A타입]","index":"g4li"},{"part":"모자","icon":"pr_acap/00111.png","name":"홀리아머 투구[D타입]","index":"asli"},{"part":"얼굴","icon":"pr_aface/00193.png","name":"보석 둠 마스크[A타입]","index":"4zai"},{"part":"목가슴","icon":"pr_aneck/00106.png","name":"만진의 망토","index":"sfai"},{"part":"상의","icon":"pr_acoat/00124.png","name":"백호의 가죽상의","index":"06ai"},{"part":"허리","icon":"pr_abelt/00148.png","name":"화랑의 노리개 요갑[D타입]","index":"3xmi"},{"part":"하의","icon":"pr_apants/00127.png","name":"표범무늬 수영 팬츠[B타입]","index":"1jmi"},{"part":"신발","icon":"pr_ashoes/00061.png","name":"무반의 사냥신[A타입]","index":"jtmi"}],"title":"TestDate2","email":"test1@naver.com"}]';


  @override
  void initState() {
    super.initState();
    // Future.microtask를 사용하여 build 메소드 이후에 ModalRoute의 값을 가져옴
    Future.microtask(() async {
      emailFromRoute = ModalRoute.of(context)?.settings.arguments.toString();
      setState(() {
        useremail = emailFromRoute ?? '';
      });
      fetchHistory();
    });
  }

  Future fetchHistory() async {
    history = jsonDecode(jsonString);
    //final response =
    //    await http.get(Uri.parse('${history_check_url}/test1@naver.com'));
    //print('저장 내역 statusCode : ${response.statusCode}');
//
    //if (response.statusCode == 200) {
    //  var responseBody = utf8.decode(response.bodyBytes);
    //  history = jsonDecode(responseBody);
    //  save_list_length = response.body.length;
    //} else {
    //  showDialog(
    //    context: context,
    //    builder: (BuildContext context) {
    //      return AlertDialog(
    //        title: Text(
    //          '오류',
    //          textAlign: TextAlign.center,
    //        ),
    //        content: Text(
    //          '저장 기록을 불러오는 중 오류가 발생했습니다.',
    //          textAlign: TextAlign.center,
    //        ),
    //        actions: [
    //          TextButton(
    //            onPressed: () =>
    //                Navigator.popUntil(context, (route) => route.isFirst),
    //            child: Text('확인'),
    //          ),
    //        ],
    //      );
    //    },
    //  );
    //}
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (history.isNotEmpty) {
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
                    itemCount: history.isEmpty ? 1 : history.length,
                    itemBuilder: (context, index) {
                      if (history.isNotEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/check',
                                    arguments: history[index]);
                              },
                              child: Container(
                                height: double.infinity,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  children: [
                                    Text('${history[index]['title']}'),
                                    SizedBox(height: 5),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: 8,
                                        itemBuilder: (context, i) => Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${history[index]['data'][i]['part']} : ${history[index]['data'][i]['name']}',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
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
