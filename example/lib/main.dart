import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_read/flutter_read.dart';

import 'menu.dart';

// 新增的简介页面和章节结束页面
final Widget summaryPage = Container(
  padding: EdgeInsets.all(16),
  child: Column(
    children: [
      Text('书籍简介', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      SizedBox(height: 16),
      Text(
          '这是一本演示用的书籍，用于展示flutter_read库的功能。\n\n主要内容包括设置简介页面和章节结束页面，以及章节评分和互动页面等功能。'),
    ],
  ),
);

final Widget chapterEndPage = Container(
  padding: EdgeInsets.all(16),
  child: Column(
    children: [
      Text('章节结束', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      SizedBox(height: 16),
      Text('你已经读完了本章内容。\n\n现在你可以对本章进行评分，并参与讨论。'),
      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          return Icon(Icons.star, color: Colors.amber);
        }),
      ),
    ],
  ),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ReadController bookController = ReadController.create(
    loadingWidget: const Center(
      child: CircularProgressIndicator(),
    ),
    enableVerticalDrag: true,
    enableTapPage: true,
  );
  PersistentBottomSheetController? _menuController;

  @override
  void initState() {
    start();
    super.initState();
  }

  Future<void> start() async {
    DateTime now = DateTime.now();
    BookSource source = ByteDataSource(
        await rootBundle.load("assets/books/novel.txt"), "橙红年代",
        isSplit: true);

    bookController.setSummaryWidget(summaryPage);
    // 在第一章末尾添加章节结束页面
    bookController.onBookDataListCallback =
        (chapterIndex, title, bookDataList) {
      if (chapterIndex == 0 && bookDataList.length > 0) {
        bookDataList
            .add(PaintData(chapterIndex, title, widget: chapterEndPage));
      }
    };
    int state = await bookController.startReadBook(source);
    Duration duration = DateTime.now().difference(now);
    debugPrint("wwww,loading time, $duration, $state");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFE2E8DC),
        body: SafeArea(
          child: Builder(builder: (context) {
            return ReadView(
              readController: bookController,
              onMenu: () {
                if (_menuController == null) {
                  _menuController = showBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    enableDrag: false,
                    builder: (context) => BookMenu(
                      bookController: bookController,
                    ),
                  )..closed.then((value) {
                      _menuController = null;
                    });
                } else {
                  _menuController?.close();
                }
              },
              onScroll: () {
                _menuController?.close();
              },
            );
          }),
        ),
      ),
    );
  }
}
