import 'package:flutter/material.dart';
import 'package:nour_alislam/png_viewer_page.dart';
import 'package:qcf_quran/qcf_quran.dart';

import 'BookFunctionsClass.dart';

class SurahIndexPage extends StatelessWidget {
  const SurahIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    final surahs = List.generate(totalSurahCount, (i) => i + 1);

    return Scaffold(

appBar:         AppBar(
          // Ensures the title isn't forced to center on iOS
         centerTitle: false,
          title: const Align(
           alignment: Alignment.centerRight,
            child: Text('اختيار السورة'),
          ),
        ),

      body: ListView.builder(
        itemCount: surahs.length,
        itemBuilder: (context, index) {
          final surahNum = surahs[index];
          final nameArabic = getSurahNameArabic(surahNum);
          //final nameEnglish = getSurahNameEnglish(surahNum);
          final verseCount = getVerseCount(surahNum);
          //final revelation = getPlaceOfRevelation(surahNum);

          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListTile(
              dense: true, // Shrinks font sizes and overall layout padding
              visualDensity: VisualDensity(vertical: -4), // Compresses vertical spacing
              contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
              tileColor: index%2==0?Colors.cyanAccent:Colors.greenAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              leading: CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  '$surahNum',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    nameArabic,
                    style: const TextStyle(fontSize: 18),
                    textDirection: TextDirection.rtl,
                  )

                ],
              ),

              trailing: const Icon(Icons.chevron_right

              ),
              onTap:(){
                print(surahNum);
                //print("Tapped on verse $surah:$verse");
                int bookNum=1;
                int pageNum=1;
                (bookNumber: bookNum,pageNumber: pageNum)=BookFunctionsClass.findBookPageFromSurahVerse(surah: surahNum,verse: 1);
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
              }



                 // () => Navigator.pop(context, surahNum),
            ),
          );
        },
      ),
    );
  }
}
