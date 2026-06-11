import 'package:flutter/material.dart';
import 'package:nour_alislam/BookFunctionsClass.dart';
import 'package:nour_alislam/png_viewer_page.dart';
import 'package:qcf_quran/qcf_quran.dart';

class SearchByAyaPart extends StatefulWidget {
  const SearchByAyaPart({super.key});

  @override
  State<SearchByAyaPart> createState() => _SearchByAyaPartState();
}

class _SearchByAyaPartState extends State<SearchByAyaPart> {
  final _searchController = TextEditingController();
  List<Map<dynamic, dynamic>>? _results;
  int _occurrences = 0;
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    final result = searchWords(query);
    print(result);
    _results = result['result'] ;
    print(_results.runtimeType);
    _occurrences = result['occurences'] as int;

    setState(() {

      //_results = List<Map<String, dynamic>>.from(result['result'] as List);
      //_occurrences = result['occurences'] as int;
      _isSearching = false;
    });


  }

  void _navigateToVerse(int surah, int verse) {
    final (bookNumber: bookNum, pageNumber: pageNum) =
        BookFunctionsClass.findBookPageFromSurahVerse(
            surah: surah, verse: verse);
    print('booknum=${bookNum}.......pagenum=${pageNum}');
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text('البحث بجزء من آية'),
        ),
        leading: IconButton(
          icon: Image.asset('assets/icons/exit.png', width: 24, height: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'أدخل جزءاً من الآية للبحث',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  suffixIcon: IconButton(
                    icon: _isSearching
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.search),
                    onPressed:
                    (){
                      print('on pressed');
                      _search();
                      FocusManager.instance.primaryFocus?.unfocus();


                      },
                  ),
                ),
                style: const TextStyle(fontSize: 16),
                onSubmitted: (_) {
                  _search();
                  FocusManager.instance.primaryFocus?.unfocus();

                },

              ),
            ),
            if (_results != null) ...[
              const SizedBox(height: 12),
              Text(
                'عدد مرات الظهور: $_occurrences',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _results!.isEmpty
                    ? Center(
                        child: Text(
                          'لا توجد نتائج',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _results!.length,
                        itemBuilder: (context, index) {
                          final item = _results![index];
                          final surah = item['suraNumber'] as int;
                          final verse = item['verseNumber'] as int;
                          final surahName = getSurahNameArabic(surah);
                          final ayaText=getVerse(surah, verse);
                          final ayaSplitted=ayaText.split(" ");
                          final ayaWordCount=ayaSplitted.length;
                          if(ayaWordCount>10){
                          ayaSplitted.removeRange(10,ayaWordCount);}

                          final ayaShorted=ayaSplitted.join(" ");
                          //sublist(0,ayaWordCount<10?ayaWordCount:10);
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    theme.colorScheme.primaryContainer,
                                child: Text(
                                  '$surah',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme
                                        .onPrimaryContainer,
                                  ),
                                ),
                              ),
                              title: Text(
                                '$surahName - الآية $verse \n ${ayaShorted}',
                                style: const TextStyle(fontSize: 16),
                                textDirection: TextDirection.rtl,
                              ),
                              trailing: const Icon(Icons.chevron_left),
                              onTap: () => _navigateToVerse(surah, verse),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
