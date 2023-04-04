import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
