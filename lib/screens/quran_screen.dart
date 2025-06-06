import 'package:flutter/material.dart';
import '../data/models/quran_model.dart';
import '../data/services/quran_service.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final QuranService _quranService = QuranService();
  List<Surah> _surahs = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadSurahs();
  }

  Future<void> _loadSurahs() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final surahs = await _quranService.getAllSurahs();
      setState(() {
        _surahs = surahs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error =
            'حدث خطأ أثناء تحميل السور. يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('جاري تحميل السور...'),
          ],
        ),
      );
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                _error,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadSurahs,
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadSurahs,
      child: ListView.builder(
        itemCount: _surahs.length,
        itemBuilder: (context, index) {
          final surah = _surahs[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Text(
                '${surah.number}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              surah.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${surah.englishName} - ${surah.englishNameTranslation}',
              style: const TextStyle(fontSize: 14),
            ),
            trailing: Text(
              '${surah.numberOfAyahs} آيات',
              style: const TextStyle(fontSize: 14),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SurahDetailScreen(surahNumber: surah.number),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SurahDetailScreen extends StatefulWidget {
  final int surahNumber;

  const SurahDetailScreen({super.key, required this.surahNumber});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final QuranService _quranService = QuranService();
  Surah? _surah;
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadSurah();
  }

  Future<void> _loadSurah() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final surah = await _quranService.getSurah(widget.surahNumber);
      setState(() {
        _surah = surah;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error =
            'حدث خطأ أثناء تحميل السورة. يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('جاري تحميل السورة...'),
            ],
          ),
        ),
      );
    }

    if (_error.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('سورة ${widget.surahNumber}'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  _error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _loadSurah,
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_surah == null) {
      return const Scaffold(
          body: Center(child: Text('لم يتم العثور على السورة')));
    }

    return Scaffold(
      appBar: AppBar(title: Text(_surah!.name), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: _loadSurah,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _surah!.ayahs.length,
          itemBuilder: (context, index) {
            final ayah = _surah!.ayahs[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      ayah.text,
                      style: const TextStyle(fontSize: 24, height: 1.5),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'آية ${ayah.numberInSurah}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
