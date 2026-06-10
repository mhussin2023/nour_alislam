import 'package:flutter/material.dart';
import 'package:nour_alislam/png_viewer_page.dart';
import 'package:qcf_quran/qcf_quran.dart';

import 'BookFunctionsClass.dart';

class SurahIndexPage extends StatefulWidget {
  const SurahIndexPage({super.key});

  @override
  State<SurahIndexPage> createState() => _SurahIndexPageState();
}

class _SurahIndexPageState extends State<SurahIndexPage> {
  int? _selectedSurah;
  final _ayahController = TextEditingController();

  @override
  void dispose() {
    _ayahController.dispose();
    super.dispose();
  }

  void _onSurahTap(int surahNum, int verseCount) {
    if (_selectedSurah != surahNum) {
      setState(() {
        _selectedSurah = surahNum;
        _ayahController.clear();
      });
    } else {
      final ayahText = _ayahController.text.trim();
      if (ayahText.isEmpty) return;
      final ayah = int.tryParse(ayahText);
      if (ayah == null || ayah < 1 || ayah > verseCount) return;

      final (bookNumber: bookNum, pageNumber: pageNum) =
          BookFunctionsClass.findBookPageFromSurahVerse(
              surah: surahNum, verse: ayah);
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
  }

  @override
  Widget build(BuildContext context) {
    final surahs = List.generate(totalSurahCount, (i) => i + 1);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text('اختيار السورة والآية'),
        ),
        leading: IconButton(
          icon: Image.asset('assets/icons/exit.png', width: 24, height: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: surahs.length,
        itemBuilder: (context, index) {
          final surahNum = surahs[index];
          final nameArabic = getSurahNameArabic(surahNum);
          final verseCount = getVerseCount(surahNum);
          final isSelected = _selectedSurah == surahNum;

          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListTile(
              dense: true,
              visualDensity: VisualDensity(vertical: -4),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
              tileColor: index % 2 == 0 ? Colors.cyanAccent : Colors.greenAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              leading: CircleAvatar(
                radius: 18,
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  '$surahNum',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nameArabic,
                    style: const TextStyle(fontSize: 18),
                    textDirection: TextDirection.rtl,
                  ),
                  if (isSelected)
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextField(
                        controller: _ayahController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'أدخل رقم الآية (1-$verseCount)',
                          hintStyle: const TextStyle(fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          isDense: true,
                        ),
                        style: const TextStyle(fontSize: 16),
                        onSubmitted: (_) => _onSurahTap(surahNum, verseCount),
                      ),
                    ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _onSurahTap(surahNum, verseCount),
            ),
          );
        },
      ),
    );
  }
}
