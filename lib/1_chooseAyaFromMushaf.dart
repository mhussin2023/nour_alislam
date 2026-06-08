import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qcf_quran/qcf_quran.dart';
import 'BookFunctionsClass.dart';
import 'png_viewer_page.dart';

//import 'BookViewPage.dart';

class QuranHomePage extends StatefulWidget {
  final int? initialPageNumber;
  const QuranHomePage({super.key, this.initialPageNumber});

  @override
  State<QuranHomePage> createState() => _QuranHomePageState();
}

class _QuranHomePageState extends State<QuranHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(

    ),
      body: PageviewQuran(
        initialPageNumber: widget.initialPageNumber ?? 5,
        theme: QcfThemeData(),
        sp: 0.9.sp,
        ///h for responsiveness
        h: 1.h,
        textColor: Colors.black,
        onTap: (surah, verse) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => BookViewPage(
          //       initialBookNumber: surah,
          //       initialPageNumber: verse,
          //     ),
          //   ),
          // );

          print("Tapped on verse $surah:$verse");
          int bookNum=1;
          int pageNum=1;
          (bookNumber: bookNum,pageNumber: pageNum)=BookFunctionsClass.findBookPageFromSurahVerse(surah: surah,verse: verse);
          print(bookNum);
          print(pageNum);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PngViewerPage(
                bookNumber: bookNum,
                pageNumber: pageNum,
                              ),
            ),
          );

        },
        onLongPress: (surah, verse) {
          print("Long Pressed on verse $surah:$verse");
        },
        onLongPressUp: (surah, verse) {
          //print("Long Press Up on verse $surah:$verse");
        },
        onLongPressCancel: (surah, verse) {
         /// print("Long Press Cancel on verse $surah:$verse");
        },
        onLongPressDown: (surah, verse, details) {
          // print(
          //   "Long Press Down on verse $surah:$verse @ ${details.globalPosition}",
          // );
        },
      ),
    );
  }
}