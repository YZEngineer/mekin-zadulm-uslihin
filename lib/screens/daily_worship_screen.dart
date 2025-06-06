import 'package:flutter/material.dart';
import '../data/helpers/daily_worship_dao.dart';
import '../data/models/daily_worship.dart';

class DailyWorshipScreen extends StatefulWidget {
  const DailyWorshipScreen({super.key});

  @override
  State<DailyWorshipScreen> createState() => _DailyWorshipScreenState();
}

class _DailyWorshipScreenState extends State<DailyWorshipScreen> {
  final Map<String, bool> _worships = {
    'صلاة الفجر': false,
    'صلاة الظهر': false,
    'صلاة العصر': false,
    'صلاة المغرب': false,
    'صلاة العشاء': false,
    'صلاة الوتر': false,
    'قيام الليل': false,
    'قراءة القرآن': false,
    'الأذكار': false,
  };
  bool _isLoading = false;
  final DailyWorshipDao _worshipDao = DailyWorshipDao();
  DailyWorship? _currentWorship;

  @override
  void initState() {
    super.initState();
    _initializeWorships();
  }

  Future<void> _initializeWorships() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // محاولة الحصول على السجل الموجود
      var worship = await _worshipDao.getById(1);

      // إذا لم يكن هناك سجل، قم بإنشاء سجل جديد
      if (worship == null) {
        worship = DailyWorship(
          id: 1,
          fajrPrayer: false,
          dhuhrPrayer: false,
          asrPrayer: false,
          maghribPrayer: false,
          ishaPrayer: false,
          witr: false,
          qiyam: false,
          quran_reading: false,
          thikr: false,
        );
        final id = await _worshipDao.insert(worship);
        worship = worship.copyWith(id: id);
      }

      _currentWorship = worship;

      // تحديث الواجهة بالقيم من قاعدة البيانات
      setState(() {
        _worships['صلاة الفجر'] = worship?.fajrPrayer ?? false;
        _worships['صلاة الظهر'] = worship?.dhuhrPrayer ?? false;
        _worships['صلاة العصر'] = worship?.asrPrayer ?? false;
        _worships['صلاة المغرب'] = worship?.maghribPrayer ?? false;
        _worships['صلاة العشاء'] = worship?.ishaPrayer ?? false;
        _worships['صلاة الوتر'] = worship?.witr ?? false;
        _worships['قيام الليل'] = worship?.qiyam ?? false;
        _worships['قراءة القرآن'] = worship?.quran_reading ?? false;
        _worships['الأذكار'] = worship?.thikr ?? false;
        _isLoading = false;
      });
    } catch (e) {
      print('خطأ أثناء تهيئة العبادات: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ أثناء تهيئة العبادات')),
        );
      }
    }
  }

  Future<void> _saveWorship(String worship, bool value) async {
    if (_currentWorship == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // تحديث القيمة في الخريطة
      _worships[worship] = value;

      // تحديث القيمة في النموذج
      final updatedWorship = _currentWorship!.copyWith(
        fajrPrayer:
            worship == 'صلاة الفجر' ? value : _currentWorship!.fajrPrayer,
        dhuhrPrayer:
            worship == 'صلاة الظهر' ? value : _currentWorship!.dhuhrPrayer,
        asrPrayer: worship == 'صلاة العصر' ? value : _currentWorship!.asrPrayer,
        maghribPrayer:
            worship == 'صلاة المغرب' ? value : _currentWorship!.maghribPrayer,
        ishaPrayer:
            worship == 'صلاة العشاء' ? value : _currentWorship!.ishaPrayer,
        witr: worship == 'صلاة الوتر' ? value : _currentWorship!.witr,
        qiyam: worship == 'قيام الليل' ? value : _currentWorship!.qiyam,
        quran_reading:
            worship == 'قراءة القرآن' ? value : _currentWorship!.quran_reading,
        thikr: worship == 'الأذكار' ? value : _currentWorship!.thikr,
      );

      // حفظ التغييرات في قاعدة البيانات
      await _worshipDao.update(updatedWorship);

      // تحديث النموذج الحالي
      _currentWorship = updatedWorship;

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(value ? 'تم إكمال $worship' : 'تم إلغاء $worship'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print('خطأ أثناء حفظ العبادة: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ أثناء حفظ العبادة')),
        );
      }
    }
  }

  Widget _buildLegendItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            textDirection: TextDirection.rtl,
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        _buildLegendItem('أذكار الصلاة',
            'ستغفر الله، أستغفر الله، أستغفر الله، اللهم أنت السلام، ومنك السلام، تباركت يا ذا الجلال والإكرام\nلا إله إلا الله، وحده لا شريك له، له الملك، وله الحمد، وهو على كل شيء قدير\nسبحان الله، والحمد لله، والله أكبر، ثلاثة وثلاثين مرة'),
        _buildLegendItem('قيام الليل',
            'افضله قيام داوود عليه السلام ينام نصفه وقوم ثلثه وينام سدسه الاخير'),
        _buildLegendItem(
            'التهجد', 'ركعتان بعد الاستيقاظ من النوم في جوف الليل'),
        _buildLegendItem('الوتر', 'ركعة واحدة قبل النوم'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // عند العودة للصفحة الرئيسية، نقوم بتحديث البيانات
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'العبادات اليومية',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textDirection: TextDirection.rtl,
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  GridView.builder(
                    padding: const EdgeInsets.all(16),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _worships.length,
                    itemBuilder: (context, index) {
                      final worship = _worships.keys.elementAt(index);
                      final isCompleted = _worships[worship] ?? false;

                      return Card(
                        elevation: 4,
                        child: InkWell(
                          onTap: () => _saveWorship(worship, !isCompleted),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? Colors.green.shade50
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isCompleted
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color:
                                      isCompleted ? Colors.green : Colors.grey,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  worship,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isCompleted
                                        ? Colors.green
                                        : Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildLegend(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
