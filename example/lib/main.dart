import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_read/flutter_read.dart';

import 'menu.dart';

// // 新增的简介页面和章节结束页面
// final Widget summaryPage = Container(
//   padding: const EdgeInsets.all(16),
//   child: const Column(
//     children: [
//       Text('书籍简介', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//       SizedBox(height: 16),
//       Text(
//           '这是一本演示用的书籍，用于展示flutter_read库的功能。\n\n主要内容包括设置简介页面和章节结束页面，以及章节评分和互动页面等功能。'),
//     ],
//   ),
// );

// final Widget chapterEndPage = Container(
//   padding: const EdgeInsets.all(16),
//   child: Column(
//     children: [
//       const Text('章节结束',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//       const SizedBox(height: 16),
//       const Text('你已经读完了本章内容。\n\n现在你可以对本章进行评分，并参与讨论。'),
//       const SizedBox(height: 16),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: List.generate(5, (index) {
//           return const Icon(Icons.star, color: Colors.amber);
//         }),
//       ),
//     ],
//   ),
// );

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
    readStyle: ReadStyle(
        titlePadding:
            const EdgeInsets.only(top: 100, bottom: 100, left: 0, right: 0),
        bgImage: const AssetImage("assets/images/bg.jpg")),
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
        await rootBundle.load("assets/books/Phineas Redux.txt"),
        "Phineas Redux",
        isSplit: true);

    // bookController.setSummaryWidget(summaryPage);
    // // 在第一章末尾添加章节结束页面
    // bookController.onBookDataListCallback =
    //     (chapterIndex, title, bookDataList) {
    //   if (chapterIndex == 0 && bookDataList.isNotEmpty) {
    //     bookDataList
    //         .add(PaintData(chapterIndex, title, widget: chapterEndPage));
    //   }
    // };
    int state = await bookController.startReadBook(source);
    Duration duration = DateTime.now().difference(now);
    debugPrint("wwww,loading time, $duration, $state");

    // ChapterData chapterData = ChapterData(wordIndex: 0, chapterIndex: 0);
    // BookSource bookSource = StringSource(
    //     "1The circumstances of the general election of 18 — will be well remembered by all those who take an interest in the political matters of the country. There had been a coming in and a going out of ministers previous to that — somewhat rapid, very exciting, and, upon the whole, useful as showing the real feeling of the country upon sundry questions of public interest. Mr Gresham had been Prime Minister of England, as representative of the Liberal party in politics. There had come to be a split among those who should have been his followers on the terribly vexed question of the Ballot. Then Mr Daubeny for twelve months had sat upon the throne distributing the good things of the Crown amidst Conservative birdlings, with beaks wide open and craving maws, who certainly for some years previous had not received their share of State honours or State emoluments. And Mr Daubeny was still so sitting, to the infinite dismay of the Liberals, every man of whom felt that his party was entitled by numerical strength to keep the management of the Government within its own hands.",
    //     "Chapter 1 TemptationTemptationTemptationTemptationTemptation",
    //     isSplit: true);
    // await bookController.addChapter(bookSource, 0);
    // BookSource bookSource2 = StringSource(
    //     "2The circumstances of the general election of 18 — will be well remembered by all those who take an interest in the political matters of the country. There had been a coming in and a going out of ministers previous to that — somewhat rapid, very exciting, and, upon the whole, useful as showing the real feeling of the country upon sundry questions of public interest. Mr Gresham had been Prime Minister of England, as representative of the Liberal party in politics. There had come to be a split among those who should have been his followers on the terribly vexed question of the Ballot. Then Mr Daubeny for twelve months had sat upon the throne distributing the good things of the Crown amidst Conservative birdlings, with beaks wide open and craving maws, who certainly for some years previous had not received their share of State honours or State emoluments. And Mr Daubeny was still so sitting, to the infinite dismay of the Liberals, every man of whom felt that his party was entitled by numerical strength to keep the management of the Government within its own hands.",
    //     "Chapter 2 Temptation",
    //     isSplit: true);
    // await bookController.addChapter(bookSource2, 1);

    // BookSource bookSource3 = StringSource("", "", isSplit: true);

    // int state = await bookController.startReadChapter(bookSource3, chapterData);
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
