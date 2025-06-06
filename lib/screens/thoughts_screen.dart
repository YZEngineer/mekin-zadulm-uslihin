import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../data/models/thought_model.dart';
import '../data/services/thought_service.dart';

class ThoughtsScreen extends StatefulWidget {
  const ThoughtsScreen({super.key});

  @override
  State<ThoughtsScreen> createState() => _ThoughtsScreenState();
}

class _ThoughtsScreenState extends State<ThoughtsScreen> {
  final ThoughtService _thoughtService = ThoughtService();
  List<Thought> _thoughts = [];
  ThoughtType? _selectedType;
  Map<ThoughtType, int> _typeCounts = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final counts = await _thoughtService.getThoughtTypeCounts();
      final thoughts = _selectedType != null
          ? await _thoughtService.getThoughtsByType(_selectedType!)
          : await _thoughtService.getAllThoughts();
      setState(() {
        _typeCounts = counts;
        _thoughts = thoughts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
      }
    }
  }

  Future<void> _addThought() async {
    final result = await showDialog<Thought>(
      context: context,
      builder: (context) => const ThoughtDialog(),
    );

    if (result != null) {
      await _thoughtService.insertThought(result);
      _loadData();
    }
  }

  Future<void> _editThought(Thought thought) async {
    final result = await showDialog<Thought>(
      context: context,
      builder: (context) => ThoughtDialog(thought: thought),
    );

    if (result != null) {
      await _thoughtService.updateThought(result);
      _loadData();
    }
  }

  Future<void> _deleteThought(Thought thought) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذه الخاطرة؟'),
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
      await _thoughtService.deleteThought(thought.id!);
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('سجل الخواطر'), centerTitle: true),
      body: Column(
        children: [
          _buildTypeSummary(),
          _buildTypeFilter(),
          Expanded(
            child: _thoughts.isEmpty
                ? const Center(
                    child: Text(
                      'لا توجد خواطر',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _thoughts.length,
                    itemBuilder: (context, index) {
                      final thought = _thoughts[index];
                      return _buildThoughtCard(thought);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addThought,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTypeSummary() {
    final total = _typeCounts.values.fold(0, (sum, count) => sum + count);
    if (total == 0) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'ملخص الخواطر',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTypeCount(
                  'دنيوي',
                  _typeCounts[ThoughtType.worldly] ?? 0,
                  total,
                  Colors.blue,
                ),
                _buildTypeCount(
                  'أخروي',
                  _typeCounts[ThoughtType.hereafter] ?? 0,
                  total,
                  Colors.green,
                ),
                _buildTypeCount(
                  'كلاهما',
                  _typeCounts[ThoughtType.both] ?? 0,
                  total,
                  Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeCount(String label, int count, int total, Color color) {
    final percentage = total > 0
        ? (count / total * 100).toStringAsFixed(1)
        : '0';
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 4),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text('$percentage%', style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }

  Widget _buildTypeFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          FilterChip(
            label: const Text('الكل'),
            selected: _selectedType == null,
            onSelected: (selected) {
              setState(() => _selectedType = null);
              _loadData();
            },
          ),
          const SizedBox(width: 8),
          ...ThoughtType.values.map((type) {
            final label = type == ThoughtType.worldly
                ? 'دنيوي'
                : type == ThoughtType.hereafter
                ? 'أخروي'
                : 'كلاهما';
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: FilterChip(
                label: Text(label),
                selected: _selectedType == type,
                onSelected: (selected) {
                  setState(() => _selectedType = selected ? type : null);
                  _loadData();
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildThoughtCard(Thought thought) {
    final typeLabel = thought.type == ThoughtType.worldly
        ? 'دنيوي'
        : thought.type == ThoughtType.hereafter
        ? 'أخروي'
        : 'كلاهما';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(typeLabel),
                  backgroundColor: thought.type == ThoughtType.worldly
                      ? Colors.blue.withOpacity(0.2)
                      : thought.type == ThoughtType.hereafter
                      ? Colors.green.withOpacity(0.2)
                      : Colors.purple.withOpacity(0.2),
                ),
                Text(
                  DateFormat('yyyy/MM/dd').format(thought.createdAt),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              thought.content,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editThought(thought),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteThought(thought),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ThoughtDialog extends StatefulWidget {
  final Thought? thought;

  const ThoughtDialog({super.key, this.thought});

  @override
  State<ThoughtDialog> createState() => _ThoughtDialogState();
}

class _ThoughtDialogState extends State<ThoughtDialog> {
  late TextEditingController _contentController;
  late ThoughtType _selectedType;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.thought?.content);
    _selectedType = widget.thought?.type ?? ThoughtType.worldly;
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.thought == null ? 'إضافة خاطرة' : 'تعديل الخاطرة'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'الخاطرة',
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ThoughtType>(
              value: _selectedType,
              decoration: const InputDecoration(labelText: 'نوع الخاطرة'),
              items: [
                DropdownMenuItem(
                  value: ThoughtType.worldly,
                  child: const Text('دنيوي'),
                ),
                DropdownMenuItem(
                  value: ThoughtType.hereafter,
                  child: const Text('أخروي'),
                ),
                DropdownMenuItem(
                  value: ThoughtType.both,
                  child: const Text('كلاهما'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        TextButton(
          onPressed: () {
            if (_contentController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('الرجاء إدخال الخاطرة')),
              );
              return;
            }

            final thought = Thought(
              id: widget.thought?.id,
              content: _contentController.text.trim(),
              type: _selectedType,
              createdAt: widget.thought?.createdAt ?? DateTime.now(),
            );

            Navigator.pop(context, thought);
          },
          child: const Text('حفظ'),
        ),
      ],
    );
  }
}
