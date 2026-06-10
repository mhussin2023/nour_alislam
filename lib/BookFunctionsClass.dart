import "data_Files/Book_final.dart";
import 'data_Files/book_files_links.dart';
import 'package:qcf_quran/qcf_quran.dart' as Quran;

class BookFunctionsClass {

  static ({int bookNumber, int pageNumber }) findBookPageFromSurahVerse(
      {required int surah, required int verse}) {
    List<int> found = bookDataList.firstWhere(
            (element) {
          return element[0] == verse && element[3] == surah;
        });

    return (bookNumber: found[4], pageNumber: found[2]);
  }
}