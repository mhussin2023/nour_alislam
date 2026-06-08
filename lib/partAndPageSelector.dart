import 'package:flutter/material.dart';

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


  final List<String> pageChoices = List.generate(100, (index) => (index + 1).toString());

  String? selectedPart;
  String? selectedPage;

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
            DropdownButtonFormField<String>(
              value: selectedPage,
              decoration: const InputDecoration(
                labelText: 'رقم الصفحة',
                border: OutlineInputBorder(),
              ),
              items: pageChoices.map((page) {
                return DropdownMenuItem(value: page, child: Text(page));
              }).toList(),
              onChanged: (val) => setState(() => selectedPage = val),
            ),
          ],
        ),
      ),
    );
  }
}
