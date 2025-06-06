import 'package:flutter/material.dart';
import 'package:zadulmuslihin/data/database/database_helper.dart';
import 'package:zadulmuslihin/data/helpers/athkar_dao.dart';
import 'package:zadulmuslihin/data/helpers/hadith_dao.dart';
import 'package:zadulmuslihin/data/helpers/quran_dua_dao.dart';
import 'package:zadulmuslihin/data/models/athkar.dart';
import 'package:zadulmuslihin/data/models/hadith.dart';
import 'package:zadulmuslihin/data/models/quran_dua.dart';

class IslamicInfoScreen extends StatefulWidget {
  const IslamicInfoScreen({super.key});

  @override
  State<IslamicInfoScreen> createState() => _IslamicInfoScreenState();
}

class _IslamicInfoScreenState extends State<IslamicInfoScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  late final AthkarDao _athkarDao;
  late final HadithDao _hadithDao;
  late final QuranDuaDao _quranDuaDao;

  List<Athkar> _athkarList = [];
  List<Hadith> _hadithsList = [];
  List<QuranDua> _quranDuasList = [];

  bool _isLoadingAthkar = false;
  bool _isLoadingHadiths = false;
  bool _isLoadingQuranDuas = false;

  @override
  void initState() {
    super.initState();
    _athkarDao = AthkarDao(_dbHelper);
    _hadithDao = HadithDao(_dbHelper);
    _quranDuaDao = QuranDuaDao(_dbHelper);
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadAthkar(),
      _loadHadiths(),
      _loadQuranDuas(),
    ]);
  }

  Future<void> _loadAthkar() async {
    setState(() => _isLoadingAthkar = true);
    try {
      final athkar = await _athkarDao.getAll();
      setState(() {
        _athkarList = athkar;
        _isLoadingAthkar = false;
      });
    } catch (e) {
      setState(() => _isLoadingAthkar = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ اثثناء تخميل الاذكار: $e')),
        );
      }
    }
  }

  Future<void> _loadHadiths() async {
    setState(() => _isLoadingHadiths = true);
    try {
      final hadiths = await _hadithDao.getAll();
      setState(() {
        _hadithsList = hadiths;
        _isLoadingHadiths = false;
      });
    } catch (e) {
      setState(() => _isLoadingHadiths = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في تحميل الاحاديث: $e')),
        );
      }
    }
  }

  Future<void> _loadQuranDuas() async {
    setState(() => _isLoadingQuranDuas = true);
    try {
      final duas = await _quranDuaDao.getAll();
      setState(() {
        _quranDuasList = duas;
        _isLoadingQuranDuas = false;
      });
    } catch (e) {
      setState(() => _isLoadingQuranDuas = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('قران: $e')),
        );
      }
    }
  }

  // Zikir işlemleri
  Future<void> _addAthkar() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _AthkarDialog(),
    );

    if (result != null) {
      try {
        await _athkarDao.insert(Athkar(
          title: result['title']!,
          content: result['content']!,
        ));
        await _loadAthkar();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إضافة الذكر بنجاح')),
          );
        }
      } catch (e) {
        print('خطأ في إضافة الذكر: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('حدث خطأ أثناء إضافة الذكر: $e')),
          );
        }
      }
    }
  }

  Future<void> _editAthkar(Athkar athkar) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _AthkarDialog(
        initialTitle: athkar.title,
        initialContent: athkar.content,
      ),
    );

    if (result != null) {
      try {
        await _athkarDao.update(athkar.copyWith(
          title: result['title']!,
          content: result['content']!,
        ));
        await _loadAthkar();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تحديث الذكر بنجاح')),
          );
        }
      } catch (e) {
        print('خطأ في تحديث الذكر: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('حدث خطأ أثناء تحديث الذكر: $e')),
          );
        }
      }
    }
  }

  Future<void> _deleteAthkar(Athkar athkar) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Zikri Sil'),
        content: const Text('Bu zikri silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _athkarDao.delete(athkar.id!);
        await _loadAthkar();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حذف الذكر بنجاح')),
          );
        }
      } catch (e) {
        print('خطأ في حذف الذكر: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('حدث خطأ أثناء حذف الذكر: $e')),
          );
        }
      }
    }
  }

  // Hadis işlemleri
  Future<void> _addHadith() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _HadithDialog(),
    );

    if (result != null) {
      try {
        await _hadithDao.insert(Hadith(
          text: result['text']!,
          narrator: result['narrator']!,
          topic: result['topic']!,
        ));
        await _loadHadiths();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إضافة الحديث بنجاح')),
          );
        }
      } catch (e) {
        print('خطأ في إضافة الحديث: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('حدث خطأ أثناء إضافة الحديث: $e')),
          );
        }
      }
    }
  }

  Future<void> _editHadith(Hadith hadith) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _HadithDialog(
        initialText: hadith.text,
        initialNarrator: hadith.narrator,
        initialTopic: hadith.topic,
      ),
    );

    if (result != null) {
      try {
        await _hadithDao.update(hadith.copyWith(
          text: result['text']!,
          narrator: result['narrator']!,
          topic: result['topic']!,
        ));
        await _loadHadiths();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تحديث الحديث بنجاح')),
          );
        }
      } catch (e) {
        print('خطأ في تحديث الحديث: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('حدث خطأ أثناء تحديث الحديث: $e')),
          );
        }
      }
    }
  }

  Future<void> _deleteHadith(Hadith hadith) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hadisi Sil'),
        content: const Text('Bu hadisi silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _hadithDao.delete(hadith.id!);
        await _loadHadiths();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حذف الحديث بنجاح')),
          );
        }
      } catch (e) {
        print('خطأ في حذف الحديث: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('حدث خطأ أثناء حذف الحديث: $e')),
          );
        }
      }
    }
  }

  // Kur'an Duası işlemleri
  Future<void> _addQuranDua() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _QuranDuaDialog(),
    );

    if (result != null) {
      try {
        await _quranDuaDao.insert(QuranDua(
          text: result['text']!,
          source: result['source']!,
          theme: result['theme']!,
        ));
        await _loadQuranDuas();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إضافة الدعاء بنجاح')),
          );
        }
      } catch (e) {
        print('خطأ في إضافة الدعاء: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('حدث خطأ أثناء إضافة الدعاء: $e')),
          );
        }
      }
    }
  }

  Future<void> _editQuranDua(QuranDua dua) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _QuranDuaDialog(
        initialText: dua.text,
        initialSource: dua.source,
        initialTheme: dua.theme,
      ),
    );

    if (result != null) {
      try {
        await _quranDuaDao.update(dua.copyWith(
          text: result['text']!,
          source: result['source']!,
          theme: result['theme']!,
        ));
        await _loadQuranDuas();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تحديث الدعاء بنجاح')),
          );
        }
      } catch (e) {
        print('خطأ في تحديث الدعاء: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('حدث خطأ أثناء تحديث الدعاء: $e')),
          );
        }
      }
    }
  }

  Future<void> _deleteQuranDua(QuranDua dua) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Duayı Sil'),
        content: const Text('Bu duayı silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _quranDuaDao.delete(dua.id!);
        await _loadQuranDuas();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حذف الدعاء بنجاح')),
          );
        }
      } catch (e) {
        print('خطأ في حذف الدعاء: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('حدث خطأ أثناء حذف الدعاء: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: 'أذكار'),
              Tab(text: 'أحاديث'),
              Tab(text: 'أدعية من القران'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAthkarTab(),
            _buildHadithsTab(),
            _buildQuranDuasTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAthkarTab() {
    if (_isLoadingAthkar) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_athkarList.isEmpty) {
      return const Center(child: Text('Henüz zikir eklenmemiş'));
    }

    return Scaffold(
      body: ListView.builder(
        itemCount: _athkarList.length,
        itemBuilder: (context, index) {
          final athkar = _athkarList[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(athkar.title),
              subtitle: Text(athkar.content),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editAthkar(athkar),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteAthkar(athkar),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAthkar,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHadithsTab() {
    if (_isLoadingHadiths) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hadithsList.isEmpty) {
      return const Center(child: Text('Henüz hadis eklenmemiş'));
    }

    return Scaffold(
      body: ListView.builder(
        itemCount: _hadithsList.length,
        itemBuilder: (context, index) {
          final hadith = _hadithsList[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(hadith.text),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ravi: ${hadith.narrator}'),
                  Text('Konu: ${hadith.topic}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editHadith(hadith),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteHadith(hadith),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHadith,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildQuranDuasTab() {
    if (_isLoadingQuranDuas) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_quranDuasList.isEmpty) {
      return const Center(child: Text('Henüz dua eklenmemiş'));
    }

    return Scaffold(
      body: ListView.builder(
        itemCount: _quranDuasList.length,
        itemBuilder: (context, index) {
          final dua = _quranDuasList[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(dua.text),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kaynak: ${dua.source}'),
                  Text('Konu: ${dua.theme}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editQuranDua(dua),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteQuranDua(dua),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addQuranDua,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Dialog sınıfları
class _AthkarDialog extends StatefulWidget {
  final String? initialTitle;
  final String? initialContent;

  const _AthkarDialog({
    this.initialTitle,
    this.initialContent,
  });

  @override
  State<_AthkarDialog> createState() => _AthkarDialogState();
}

class _AthkarDialogState extends State<_AthkarDialog> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _contentController = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.initialTitle == null ? 'Yeni Zikir Ekle' : 'Zikri Düzenle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Başlık'),
          ),
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(labelText: 'İçerik'),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        TextButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty &&
                _contentController.text.isNotEmpty) {
              Navigator.pop(context, {
                'title': _titleController.text,
                'content': _contentController.text,
              });
            }
          },
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}

class _HadithDialog extends StatefulWidget {
  final String? initialText;
  final String? initialNarrator;
  final String? initialTopic;

  const _HadithDialog({
    this.initialText,
    this.initialNarrator,
    this.initialTopic,
  });

  @override
  State<_HadithDialog> createState() => _HadithDialogState();
}

class _HadithDialogState extends State<_HadithDialog> {
  late TextEditingController _textController;
  late TextEditingController _narratorController;
  late TextEditingController _topicController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText);
    _narratorController = TextEditingController(text: widget.initialNarrator);
    _topicController = TextEditingController(text: widget.initialTopic);
  }

  @override
  void dispose() {
    _textController.dispose();
    _narratorController.dispose();
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.initialText == null ? 'Yeni Hadis Ekle' : 'Hadisi Düzenle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _textController,
            decoration: const InputDecoration(labelText: 'Hadis Metni'),
            maxLines: 3,
          ),
          TextField(
            controller: _narratorController,
            decoration: const InputDecoration(labelText: 'Ravi'),
          ),
          TextField(
            controller: _topicController,
            decoration: const InputDecoration(labelText: 'Konu'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        TextButton(
          onPressed: () {
            if (_textController.text.isNotEmpty &&
                _narratorController.text.isNotEmpty &&
                _topicController.text.isNotEmpty) {
              Navigator.pop(context, {
                'text': _textController.text,
                'narrator': _narratorController.text,
                'topic': _topicController.text,
              });
            }
          },
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}

class _QuranDuaDialog extends StatefulWidget {
  final String? initialText;
  final String? initialSource;
  final String? initialTheme;

  const _QuranDuaDialog({
    this.initialText,
    this.initialSource,
    this.initialTheme,
  });

  @override
  State<_QuranDuaDialog> createState() => _QuranDuaDialogState();
}

class _QuranDuaDialogState extends State<_QuranDuaDialog> {
  late TextEditingController _textController;
  late TextEditingController _sourceController;
  late TextEditingController _themeController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText);
    _sourceController = TextEditingController(text: widget.initialSource);
    _themeController = TextEditingController(text: widget.initialTheme);
  }

  @override
  void dispose() {
    _textController.dispose();
    _sourceController.dispose();
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text(widget.initialText == null ? 'Yeni Dua Ekle' : 'Duayı Düzenle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _textController,
            decoration: const InputDecoration(labelText: 'Dua Metni'),
            maxLines: 3,
          ),
          TextField(
            controller: _sourceController,
            decoration: const InputDecoration(labelText: 'Kaynak'),
          ),
          TextField(
            controller: _themeController,
            decoration: const InputDecoration(labelText: 'Konu'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        TextButton(
          onPressed: () {
            if (_textController.text.isNotEmpty &&
                _sourceController.text.isNotEmpty &&
                _themeController.text.isNotEmpty) {
              Navigator.pop(context, {
                'text': _textController.text,
                'source': _sourceController.text,
                'theme': _themeController.text,
              });
            }
          },
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}
