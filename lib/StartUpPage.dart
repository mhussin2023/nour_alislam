import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_alislam/partAndPageSelector.dart';
import 'package:nour_alislam/searchByAyaPart.dart';
import 'package:nour_alislam/surah_index_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '1_chooseAyaFromMushaf.dart';

class StartUpPage extends StatefulWidget {
  const StartUpPage({super.key});

  @override
  State<StartUpPage> createState() => _StartUpPageState();
}

class _StartUpPageState extends State<StartUpPage> {
  bool _showPageInput = false;
  final _pageController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _exitApp() {
    imageCache.clear();
    imageCache.clearLiveImages();
    WidgetsBinding.instance.performReassemble();
    SystemNavigator.pop();
  }

  void _onPageSubmit() {
    final text = _pageController.text.trim();
    if (text.isEmpty) return;
    final page = int.tryParse(text);
    if (page == null || page < 1 || page > 604) return;

    print('reached route');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ScreenUtilInit(
              designSize: const Size(392.72727272727275, 800.7272727272727),
              minTextAdapt: true,
              builder: (context, child) {
                return   QuranHomePage(
                  initialPageNumber: page,
                );

              },
            )
        //     PngViewerPage(
        //   bookNumber: 1,
        //   pageNumber: page,
        // ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Center(
            child: const Text(
              textAlign: TextAlign.center,
                'نور الإسلام \n فى جمع قراءات خير الكلام')
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text(
                'اختر طريقة للبحث',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Directionality(
                textDirection: TextDirection.rtl,
                child: _MenuButton(
                  icon: Icons.auto_stories,
                  label: 'اختيار رقم صفحة من مصحف المدينة',
                  onTap: () {
                    setState(() {
                      _showPageInput = !_showPageInput;
                    });
                  },
                  additionalContent: _showPageInput
                      ? TextField(
                          controller: _pageController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'أدخل رقم الصفحة (1-604)',
                            hintStyle: const TextStyle(fontSize: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            isDense: true,
                            filled: true,
                            fillColor: theme.colorScheme.surface,
                          ),
                          style: const TextStyle(fontSize: 16),
                          onSubmitted: (_) => _onPageSubmit(),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              Directionality(
                textDirection: TextDirection.rtl,
                child: _MenuButton(
                  icon: Icons.sort_by_alpha,
                  label: 'اختيار السورة والآية ',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SurahIndexPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Directionality(
                textDirection: TextDirection.rtl,
                child: _MenuButton(
                  icon: Icons.numbers,
                  label: 'اختيار رقم صفحة من الكتاب',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PartAndPageSelector(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Directionality(
                textDirection: TextDirection.rtl,
              child:
              _MenuButton(
                icon: Icons.search,
                label: 'البحث بجزء من آية',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchByAyaPart(),
                    ),
                  );
                },
              )
              ),
              const SizedBox(height: 24),
              Directionality(
                textDirection: TextDirection.rtl,
                child: _MenuButton(
                  color: Colors.red[200],
                  icon: Icons.power_settings_new,
                  label: 'خروج',
                  onTap: _exitApp,
                ),
              ),
              const SizedBox(height: 32),
              TextButton(
                onPressed: () async {
                  final Uri url = Uri.parse(
                      'https://www.termsfeed.com/live/2cd9718d-11e2-46c1-a031-f5e633baa924'); // TODO: Replace with your actual privacy policy URL
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $url');
                  }
                },
                child: const Text(
                  'سياسة الخصوصية (Privacy Policy)',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? additionalContent;
  final Color? color;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.additionalContent,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: color ?? theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(icon, color: theme.colorScheme.onPrimaryContainer, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 18,
                    ),
                  ],
                ),
                if (additionalContent != null) ...[
                  const SizedBox(height: 12),
                  additionalContent!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
