import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 重点是 sonKey 变量，这个是为了父类调用子类使用的，因为我们在滑动名称列表的时候也需要改变指示器的位置，这个时候就需要反向改变指示器的位置
GlobalKey<_IndexBarState> sonKey = GlobalKey();

/// 字母索引控件
class LetterBar extends StatefulWidget {
  // 字母索引回调
  final void Function(String str) letterCallBack;

  // 外部传的集合
  final List<LetterBean> list;

  // 是否显示选中的背景
  final bool isShowSelectedBg;

  LetterBar({Key? key, required this.letterCallBack, required this.list, this.isShowSelectedBg = false}) : super(key: key) {
    transformLetters();
  }

  /// 将传进来的集合转换成letters集合
  void transformLetters() {
    letters.clear();
    if (list == null) {
      return;
    }
    //排序!
    List<LetterBean> tempList = [];
    tempList.addAll(list);
    tempList.sort((LetterBean a, LetterBean b) {
      return a.getLetter().compareTo(b.getLetter());
    });
    //整理获取字母集合
    for (int i = 0; i < tempList.length; i++) {
      if (i < 1 || tempList[i].getLetter() != tempList[i - 1].getLetter()) {
        letters.add(tempList[i].getLetter());
      }
    }
  }

  @override
  _IndexBarState createState() => _IndexBarState();
}

/// 获取选中的索引
int getIndex(BuildContext context, Offset globalPosition, List letters) {
  // 拿到box
  RenderBox box = context.findRenderObject() as RenderBox;
  // 拿到y值
  double y = box.globalToLocal(globalPosition).dy;
  // 算出字符高度  box的总高度/2/字符开头数组个数
  var itemHeight = MediaQuery.of(context).size.height / 2 / letters.length;
  // 算出第几个item，并且给一个取值范围
  int index = (y ~/ itemHeight).clamp(0, letters.length - 1);
  print('现在选中的是${letters[index]}');

  return index;
}

// 字母集合
final List<String> letters = [];

class _IndexBarState extends State<LetterBar> {
  double _indicatorY = 0.0; // 悬浮窗位置
  String _selectText = 'A'; // 选中的字母
  bool _isShowPop = false; // 是否 显示悬浮字母
  int indexSelect = 0;

  /// 名称列表在滑动到某些位置是，会将指示器的位置也返回过来，然后刷新指示器选择位置
  void setIndexSelect(int index) {
    setState(() {
      indexSelect = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0.0,
      height: MediaQuery.of(context).size.height / 2,
      top: MediaQuery.of(context).size.height / 4 - MediaQueryData.fromWindow(WidgetsBinding.instance!.window).padding.top - 40,
      width: 120,
      child: Row(children: [getPopLetter(), getLettersWidget()]),
    );
  }

  /// 获取 浮窗提示字母-这里设置成气泡提示，滑动的时候会在字母列表左侧有一个更大的字母提示
  Widget getPopLetter() {
    Text? popChild = _isShowPop ? Text(_selectText, style: TextStyle(fontSize: 40, color: Colors.blue)) : null;
    return Container(alignment: Alignment(0, _indicatorY), width: 100, child: popChild);
  }

  /// 获取字母控件
  Widget getLettersWidget() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(width: 20, child: Column(children: letters.asMap().map((index, e) => MapEntry(index, getItem(index, e))).values.toList())),
      onVerticalDragUpdate: (DragUpdateDetails details) {
        int index = getIndex(context, details.globalPosition, letters);
        indexSelect = index;
        setState(() {
          _selectText = letters[index];
          //根据我们索引条的Alignment的Y值进行运算的。从 -1.1 到 1.1
          //整个的Y包含的值是2.2
          _indicatorY = 2.2 / letters.length * index - 1.1;
          _isShowPop = true;
        });
        widget.letterCallBack(letters[index]);
      },
      onVerticalDragDown: (DragDownDetails details) {
        //globalPosition 自身坐标系
        int index = getIndex(context, details.globalPosition, letters);
        _selectText = letters[index];

        _indicatorY = 2.2 / letters.length * index - 1.1;
        _isShowPop = false;
        widget.letterCallBack(letters[index]);
        print('现在点击的位置是${details.globalPosition}');
        print('现在点击的位置是${indexSelect}');
        indexSelect = index;
        setState(() {});
      },
      // 当松开指示器的时候，指示器回复原样
      onVerticalDragEnd: (DragEndDetails details) {
        setState(() {
          _isShowPop = false;
        }); //触摸结束
      },
    );
  }

  /// 获取item
  Widget getItem(int index, String e) {
    BoxDecoration? decoration = widget.isShowSelectedBg
        ? BoxDecoration(color: indexSelect == index ? Colors.red : Colors.transparent, borderRadius: BorderRadius.circular(8))
        : null;
    Text text =
        Text(e, style: TextStyle(fontSize: 10, color: widget.isShowSelectedBg ? (indexSelect == index ? Colors.white : Colors.black) : Colors.black));
    return Expanded(
      child: Container(alignment: Alignment.center, child: Container(alignment: Alignment.center, decoration: decoration, child: text)),
    );
  }
}

/// 字母bean
abstract class LetterBean {
  String getLetter();
}

// 所有的字母
const INDEX_WORDS = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z'
];
