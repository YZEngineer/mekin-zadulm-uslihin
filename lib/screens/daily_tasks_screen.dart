import 'package:flutter/material.dart';
import 'package:zadulmuslihin/data/helpers/daily_task_dao.dart';
import 'package:zadulmuslihin/data/models/daily_task.dart';

class DailyTasksScreen extends StatefulWidget {
  const DailyTasksScreen({super.key});

  @override
  State<DailyTasksScreen> createState() => _DailyTasksScreenState();
}

class _DailyTasksScreenState extends State<DailyTasksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DailyTaskDao _taskDao;
  List<DailyTask> _habits = [];
  List<DailyTask> _goals = [];
  List<DailyTask> _exercises = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _taskDao = DailyTaskDao();
    _loadTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    final allTasks = await _taskDao.getAll();
    setState(() {
      _habits = allTasks.where((task) => task.category == 0).toList();
      _goals = allTasks.where((task) => task.category == 1).toList();
      _exercises = allTasks.where((task) => task.category == 2).toList();
    });
  }

  Future<void> _addNewTask(int category) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _AddTaskDialog(category: category),
    );

    if (result != null) {
      final newTask = DailyTask(
        title: result['title'],
        category: category,
        completed: false,
        workOn: false,
      );

      await _taskDao.insert(newTask);
      await _loadTasks();
    }
  }

  Future<void> _toggleWorkOn(DailyTask task) async {
    await _taskDao.update(
      task.copyWith(
        workOn: !task.workOn,
        completed: task.workOn ? task.completed : false,
      ),
    );
    await _loadTasks();
  }

  Future<void> _toggleCompleted(DailyTask task) async {
    await _taskDao.update(
      task.copyWith(
        completed: !task.completed,
        workOn: task.completed ? task.workOn : false,
      ),
    );
    await _loadTasks();
  }

  String _getCategoryTitle(int category) {
    switch (category) {
      case 0:
        return 'العادات';
      case 1:
        return 'الأهداف';
      case 2:
        return 'التمارين الرياضية';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المهام اليومية'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              // Sıfırlama onayı iste
              final shouldReset = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('إعادة تعيين المهام'),
                  content: const Text(
                    'هل أنت متأكد من إعادة تعيين جميع المهام؟',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('تأكيد'),
                    ),
                  ],
                ),
              );

              if (shouldReset == true) {
                try {
                  await _taskDao.loadDefaultTasks();
                  await _loadTasks(); 
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم إعادة تعيين المهام بنجاح'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('حدث خطأ: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'العادات'),
            Tab(text: 'الأهداف'),
            Tab(text: 'التمارين الرياضية'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskList(_habits, 0),
          _buildTaskList(_goals, 1),
          _buildTaskList(_exercises, 2),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewTask(_tabController.index),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList(List<DailyTask> tasks, int category) {
    return RefreshIndicator(
      onRefresh: _loadTasks,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.completed
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.completed ? Colors.grey : null,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.scale(
                        scale: 0.8,
                        child: Checkbox(
                          value: task.workOn,
                          onChanged: (_) => _toggleWorkOn(task),
                          activeColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: Checkbox(
                          value: task.completed,
                          onChanged: (_) => _toggleCompleted(task),
                          activeColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          if (task.id != null) {
                            await _taskDao.delete(task.id!);
                            await _loadTasks();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AddTaskDialog extends StatefulWidget {
  final int category;

  const _AddTaskDialog({required this.category});

  @override
  State<_AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<_AddTaskDialog> {
  final _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  String _getCategoryTitle(int category) {
    switch (category) {
      case 0:
        return 'عادة';
      case 1:
        return 'هدف';
      case 2:
        return 'تمرين رياضي';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('إضافة ${_getCategoryTitle(widget.category)} جديد'),
      content: TextField(
        controller: _titleController,
        decoration: InputDecoration(
          labelText: 'عنوان ${_getCategoryTitle(widget.category)}',
          border: const OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty) {
              Navigator.pop(context, {'title': _titleController.text});
            }
          },
          child: const Text('إضافة'),
        ),
      ],
    );
  }
}
