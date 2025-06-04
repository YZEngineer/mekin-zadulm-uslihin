import 'package:flutter/material.dart';
import 'selected_lessons_screen.dart';
import '../data/models/lesson.dart';
import '../data/helpers/lessons_dao.dart';
import '../core/utils/youtube_utils.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late TabController _tabController;
  final lesson_dao = LessonsDao();
  List<Lesson> _lessons = [];
  List<Lesson> _allLessons = [];
  List<Lesson> _allLessonsType1 = [];
  List<Lesson> _allLessonsType2 = [];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeDatabase();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializeDatabase() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _allLessons = await lesson_dao.getAll();
      _allLessonsType1 = await lesson_dao.getLessonByType("t1");
      _allLessonsType2 = await lesson_dao.getLessonByType("t2");
      print("initialTry...");
      print(_allLessons);
      print("... initialTry");
      // Check if database is empty
      final categories = await lesson_dao.getAll();
      if (categories.isEmpty) {
        // Add initial data
        await lesson_dao.reloadeDeletedLesson();
      }
      await _loadCategories();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
    }
  }

  Future<void> _loadCategories() async {
    try {
      final allLessons = await lesson_dao.getAll();
      final allLessonsType1 = await lesson_dao.getLessonByType("t1");
      final allLessonsType2 = await lesson_dao.getLessonByType("t2");
      setState(() {
        print("_loadCategoriesSetState...");
        print(allLessons);
        print(allLessonsType2);
        print(allLessonsType1);
        print("... _loadCategoriesSetState");
        _allLessons = allLessons;
        _lessons = allLessons;
        _allLessonsType1 = allLessonsType1;
        _allLessonsType2 = allLessonsType2;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
    }
  }

  bool _isCategoryCompleted(String lessonCategory) {
    final categoryLessons = _lessons
        .where((lesson) => lesson.category == lessonCategory)
        .toList();
    return categoryLessons.isNotEmpty &&
        categoryLessons.every((lesson) => lesson.isCompleted);
  }

  Future<void> _deleteCategory(String category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الفئة'),
        content: const Text(
          'هل أنت متأكد من حذف هذه الفئة؟ سيتم حذف جميع الدروس المرتبطة بها.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await lesson_dao.deleteCategory(category);
        await _loadCategories();
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('تم حذف الفئة بنجاح')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('حدث خطأ أثناء حذف الفئة')),
          );
        }
      }
    }
  }

  Future<void> _reloadDefaultLessons() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إعادة تحميل الدروس الافتراضية'),
        content: const Text(
          'سيتم إضافة الدروس الافتراضية المفقودة فقط. الدروس التي أضفتها لن تتأثر.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('إعادة التحميل'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        await lesson_dao.reloadeDeletedLesson();
        await _loadCategories();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إعادة تحميل الدروس الافتراضية بنجاح'),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('حدث خطأ أثناء إعادة تحميل الدروس الافتراضية'),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الفئات'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 't1'),
            Tab(text: 't2'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _reloadDefaultLessons,
            tooltip: 'إعادة تحميل الدروس الافتراضية',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCategories,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddLessonDialog(context),
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [_buildCategoryList('t1'), _buildCategoryList('t2')],
            ),
    );
  }

  Widget _buildCategoryList(String type) {
    //get unique categories
    final filteredCategories = _allLessons
        .where((c) => c.type == type)
        .map((lesson) => lesson.category)
        .toSet()
        .toList();

    return filteredCategories.isEmpty
        ? Center(child: Text('لا توجد فئات من $type'))
        : ListView.builder(
            itemCount: filteredCategories.length,
            itemBuilder: (context, index) {
              final category = filteredCategories[index];
              final isCompleted = _isCategoryCompleted(category);
              final categoryLessons = _allLessons
                  .where((l) => l.category == category)
                  .toList();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: isCompleted ? Colors.green.shade50 : null,
                child: ListTile(
                  leading: Icon(
                    Icons.folder,
                    color: isCompleted ? Colors.green.shade700 : null,
                  ),
                  title: Text(
                    category,
                    style: TextStyle(
                      color: isCompleted ? Colors.green.shade700 : null,
                      fontWeight: isCompleted ? FontWeight.bold : null,
                    ),
                  ),
                  subtitle: Text(
                    '${categoryLessons.length} دروس',
                    style: TextStyle(
                      color: isCompleted ? Colors.green.shade700 : null,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteCategory(category),
                        tooltip: 'حذف الفئة',
                      ),
                      const Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CategoryLessonsScreen(categoryName: category),
                      ),
                    ).then((_) => _loadCategories());
                  },
                ),
              );
            },
          );
  }

  Future<void> _showAddLessonDialog(BuildContext context) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final videoIdController = TextEditingController();
    final categoryController = TextEditingController();
    String selectedType = 't1';
    bool isLoading = false;
    String? videoError;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('إضافة درس جديد'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'اسم الفئة',
                    hintText: 'أدخل اسم الفئة',
                  ),
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'عنوان الدرس',
                    hintText: 'أدخل عنوان الدرس',
                  ),
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'وصف الدرس',
                    hintText: 'أدخل وصف الدرس',
                  ),
                  maxLines: 3,
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: videoIdController,
                  decoration: InputDecoration(
                    labelText: 'رابط الفيديو',
                    hintText: 'أدخل رابط الفيديو من YouTube',
                    errorText: videoError,
                  ),
                  enabled: !isLoading,
                  onChanged: (value) {
                    setState(() {
                      videoError = YoutubeUtils.getErrorMessage(value);
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(labelText: 'نوع الفئة'),
                  items: const [
                    DropdownMenuItem(value: 't1', child: Text('t1')),
                    DropdownMenuItem(value: 't2', child: Text('t2')),
                  ],
                  onChanged: isLoading
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() => selectedType = value);
                          }
                        },
                ),
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context, false),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (categoryController.text.isNotEmpty &&
                          titleController.text.isNotEmpty &&
                          descriptionController.text.isNotEmpty &&
                          videoIdController.text.isNotEmpty) {
                        // Validate YouTube URL
                        if (!YoutubeUtils.isValidYoutubeUrl(
                          videoIdController.text,
                        )) {
                          setState(() {
                            videoError = YoutubeUtils.getErrorMessage(
                              videoIdController.text,
                            );
                          });
                          return;
                        }

                        setState(() => isLoading = true);
                        try {
                          final videoId = YoutubeUtils.extractVideoId(
                            videoIdController.text,
                          );
                          if (videoId == null) {
                            throw Exception('رابط الفيديو غير صالح');
                          }

                          final lesson = Lesson(
                            category: categoryController.text,
                            title: titleController.text,
                            description: descriptionController.text,
                            videoId: videoId,
                            type: selectedType,
                          );
                          await lesson_dao.insert(lesson);
                          if (mounted) {
                            Navigator.pop(context, true);
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        } finally {
                          setState(() => isLoading = false);
                        }
                      }
                    },
              child: const Text('إضافة'),
            ),
          ],
        ),
      ),
    );

    if (result == true) {
      await _loadCategories();
    }
  }
}
