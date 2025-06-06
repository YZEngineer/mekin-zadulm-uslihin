import 'package:flutter/material.dart';
import 'package:zadulmuslihin/data/database/database.dart';
import 'package:zadulmuslihin/data/helpers/current_adhan_dao.dart';
import 'package:zadulmuslihin/data/helpers/daily_task_dao.dart';
import 'package:zadulmuslihin/data/helpers/daily_worship_dao.dart';
import 'package:zadulmuslihin/data/helpers/daily_message_dao.dart';
import 'package:zadulmuslihin/data/models/current_adhan.dart';
import 'package:zadulmuslihin/data/models/daily_worship.dart';
import 'package:zadulmuslihin/data/models/daily_message.dart';
import 'package:zadulmuslihin/data/models/daily_task.dart';
import 'package:zadulmuslihin/screens/daily_worship_screen.dart';
import 'package:zadulmuslihin/data/services/prayer_service.dart';
import 'package:zadulmuslihin/data/helpers/current_location_dao.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CurrentAdhan? _prayerTimes;
  DailyWorship? _dailyWorship;
  DailyMessage? _dailyMessage;
  List<DailyTask> _tasks = [];
  int _completedTasks = 0;
  int _totalTasks = 0;
  bool _isLoading = true;

  late CurrentAdhanDao _adhanDao;
  late DailyTaskDao _taskDao;
  late DailyWorshipDao _worshipDao;
  late DailyMessageDao _messageDao;
  late PrayerService _prayerService;
  late CurrentLocationDao _locationDao;

  @override
  void initState() {
    super.initState();
    _initDaos();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initDaos() async {
    _adhanDao = CurrentAdhanDao();
    _taskDao = DailyTaskDao();
    _worshipDao = DailyWorshipDao();
    _messageDao = DailyMessageDao();
    _prayerService = PrayerService();
    _locationDao = CurrentLocationDao();
    await _loadData();
    await _setAdhan();
  }

  Future<void> _loadData() async {
    await _setAdhan();
    setState(() {
      _isLoading = true;
    });

    try {
      print('بدء تحميل البيانات...');

      // تحميل أوقات الصلاة من قاعدة البيانات
      print('جاري تحميل أوقات الصلاة...');
      final adhan = await _adhanDao.getCurrentAdhanTimes();
      print('تم استلام أوقات الصلاة: $adhan');

      if (adhan != null) {
        setState(() {
          _prayerTimes = adhan;
          print('تم تحديث حالة أوقات الصلاة: $_prayerTimes');
        });
      } else {
        print('لم يتم العثور على أوقات صلاة');
      }

      // تحميل المهام اليومية
      print('جاري تحميل المهام اليومية...');
      final tasks = await _taskDao.getAll();
      final completedTasks = await _taskDao.getCompleted();
      setState(() {
        _tasks = tasks;
        _completedTasks = completedTasks.length;
        _totalTasks = tasks.length;
        print('تم تحميل المهام: ${tasks.length} مهمة');
      });

      // تحميل العبادة اليومية
      print('جاري تحميل العبادة اليومية...');
      final worship = await _worshipDao.getById(1);
      if (worship != null) {
        setState(() {
          _dailyWorship = worship;
          print('تم تحميل العبادة اليومية: $_dailyWorship');
        });
      } else {
        print('لم يتم العثور على عبادة يومية');
      }

      // تحميل الرسالة اليومية
      print('جاري تحميل الرسالة اليومية...');
      final today = DateTime.now();
      final messages = await _messageDao.getByDate(today);
      if (messages.isNotEmpty) {
        setState(() {
          _dailyMessage = messages.first;
          print('تم تحميل الرسالة اليومية: $_dailyMessage');
        });
      } else {
        print('لم يتم العثور على رسائل يومية للتاريخ الحالي');
      }
    } catch (e) {
      print('حدث خطأ أثناء تحميل البيانات: $e');
      debugPrint('Error loading data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ أثناء تحميل البيانات')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
        print('انتهى تحميل البيانات');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // الرسالة اليومية
                      if (_dailyMessage != null)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _dailyMessage!.title,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        _dailyMessage!.category,
                                        style: TextStyle(
                                          color: Colors.green[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _dailyMessage!.content,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                if (_dailyMessage!.source != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    'المصدر: ${_dailyMessage!.source}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        final message =
                                            '${_dailyMessage!.title}\n\n${_dailyMessage!.content}\n\nالمصدر: ${_dailyMessage!.source}';
                                        Clipboard.setData(
                                            ClipboardData(text: message));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('تم نسخ الرسالة بنجاح'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.copy, size: 20),
                                      label: const Text('نسخ الرسالة'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Prayer Times Card
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'مواقيت الصلاة',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (_prayerTimes != null) ...[
                                _buildPrayerTimeRow(
                                  'الفجر',
                                  _prayerTimes!.fajrTime,
                                ),
                                _buildPrayerTimeRow(
                                  'الشروق',
                                  _prayerTimes!.sunriseTime,
                                ),
                                _buildPrayerTimeRow(
                                  'الظهر',
                                  _prayerTimes!.dhuhrTime,
                                ),
                                _buildPrayerTimeRow(
                                  'العصر',
                                  _prayerTimes!.asrTime,
                                ),
                                _buildPrayerTimeRow(
                                  'المغرب',
                                  _prayerTimes!.maghribTime,
                                ),
                                _buildPrayerTimeRow(
                                  'العشاء',
                                  _prayerTimes!.ishaTime,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Daily Worship Summary Card
                      if (_dailyWorship != null)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'ملخص العبادات اليومية',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const DailyWorshipScreen(),
                                          ),
                                        );
                                        if (result == true) {
                                          await _loadData();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                _buildWorshipSummary(_dailyWorship!),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Daily Tasks Summary Card
                      if (_tasks.isNotEmpty)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'ملخص المهام اليومية',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildTasksSummary(_tasks),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildPrayerTimeRow(String prayerName, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(prayerName, style: const TextStyle(fontSize: 16)),
          Text(
            time,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildWorshipSummary(DailyWorship worship) {
    final total = 9; // إجمالي عدد العبادات
    int completed = 0;

    // حساب عدد العبادات المنجزة
    if (worship.fajrPrayer) completed++;
    if (worship.dhuhrPrayer) completed++;
    if (worship.asrPrayer) completed++;
    if (worship.maghribPrayer) completed++;
    if (worship.ishaPrayer) completed++;
    if (worship.witr) completed++;
    if (worship.qiyam) completed++;
    if (worship.quran_reading) completed++;
    if (worship.thikr) completed++;

    final percent = completed / total;

    // حساب عدد الصلوات المفروضة المنجزة
    int completedFard = 0;
    if (worship.fajrPrayer) completedFard++;
    if (worship.dhuhrPrayer) completedFard++;
    if (worship.asrPrayer) completedFard++;
    if (worship.maghribPrayer) completedFard++;
    if (worship.ishaPrayer) completedFard++;

    // حساب عدد السنن والنوافل المنجزة
    int completedSunnah = 0;
    if (worship.witr) completedSunnah++;
    if (worship.qiyam) completedSunnah++;

    // حساب عدد العبادات الإضافية المنجزة
    int completedExtra = 0;
    if (worship.quran_reading) completedExtra++;
    if (worship.thikr) completedExtra++;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: percent,
                    strokeWidth: 7,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                Text(
                  '${(percent * 100).toInt()}%',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أنجزت $completed من $total عبادة اليوم',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildWorshipCategory(
          'الصلوات المفروضة',
          completedFard,
          5,
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildWorshipCategory(
      String title, int completed, int total, Color color) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: total > 0 ? completed / total : 0,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$completed/$total',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTasksSummary(List<DailyTask> tasks) {
    final total = tasks.length;
    int completed = tasks.where((task) => task.completed).length;
    final percent = total > 0 ? completed / total : 0.0;

    // Kategorilere göre tamamlanan görevleri say
    int completedHabits =
        tasks.where((task) => task.category == 0 && task.completed).length;
    int completedGoals =
        tasks.where((task) => task.category == 1 && task.completed).length;
    int completedExercises =
        tasks.where((task) => task.category == 2 && task.completed).length;

    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: percent,
                strokeWidth: 7,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
            Text(
              '${(percent * 100).toInt()}%',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'أنجزت $completed من $total مهمة اليوم',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'العادات: $completedHabits | الأهداف: $completedGoals | التمارين: $completedExercises',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _setAdhan() async {
    final loc = await _locationDao.getCurrentLocation();
    final x = await _prayerService.getPrayerTimes(loc);
    await _adhanDao.ChangeCurrentAdhan(x);
  }
}
