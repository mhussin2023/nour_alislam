import 'package:flutter/material.dart';
import 'package:nour_alislam/png_viewer_page.dart';

import 'data_Files/Book_final.dart';

class PartAndPageSelector extends StatefulWidget {
  const PartAndPageSelector({super.key});

  @override
  State<PartAndPageSelector> createState() => _PartAndPageSelectorState();
}

class _PartAndPageSelectorState extends State<PartAndPageSelector> {
  final List<String> partChoices = [
    'الجزء الأول',
    'الجزء الثاني',
    'الجزء الثالث',
    'الجزء الرابع',
  ];

  final TextEditingController _pageController = TextEditingController();
  String? selectedPart;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تحديد الجزء والصفحة')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedPart,
              decoration: const InputDecoration(
                labelText: 'رقم الجزء',
                border: OutlineInputBorder(),
              ),
              items: partChoices.map((part) {
                return DropdownMenuItem(value: part, child: Text(part));
              }).toList(),
              onChanged: (val) => setState(() => selectedPart = val),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _pageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'رقم الصفحة',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (selectedPart != null && _pageController.text.isNotEmpty) {
                  final int partNumber = partChoices.indexOf(selectedPart!) + 1;
                  final int? pageInput = int.tryParse(_pageController.text);
                  if (pageInput != null && pageInput <= booksLimit[partNumber - 1] ) {
                    final int pageNumber = pageInput + 5;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PngViewerPage(
                          bookNumber: partNumber,
                          pageNumber: pageNumber,
                        ),
                      ),
                    );
                  }
                }
              },
              child: const Text("افتح الصفحة"),
            )
          ],
        ),
      ),
    );
  }
}
