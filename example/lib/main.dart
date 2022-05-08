import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:letter_bar/letter_bar.dart';
import 'package:letter_bar/letter_bar_util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await LetterBarUtil.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<TestBean> list = [];
    list.add(TestBean("拉冷", "A"));
    list.add(TestBean("笨啦", "B"));
    list.add(TestBean("测试", "C"));
    list.add(TestBean("的我", "d"));
    list.add(TestBean("俄罗斯", "e"));
    list.add(TestBean("佛罗", "f"));

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body:
        Stack(
          children: [
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            LetterBar(letterCallBack: (String str){

            }, list: list)
          ],
        )
       ,
      ),
    );
  }
}


class TestBean extends LetterBean{
  String name;
  String letter;


  TestBean(this.name, this.letter);

  @override
  String getLetter() {
    return letter;
  }

}
