import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/models/settings_model.dart';
import '../data/services/settings_service.dart';
import '../data/models/current_location.dart';
import '../data/helpers/current_location_dao.dart';
import 'package:geolocator/geolocator.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  String _locationMessage = "Fetching location...";
  bool _isLoading = true;
  late TabController _tabController;
  late Settings _settings;
  late CurrentLocation _currentLocation;
  final _locationDao = CurrentLocationDao();
  final _settingsService = SettingsService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSettings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = 'الخدمات غير مفعلة';
        _isLoading = false;
      });
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      //  لا يوجد اذن للموقع
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = 'الرجاء السماح بالموقع';
          _isLoading = false;
        });
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage = ' الموقع غير مسموح به';
        _isLoading = false;
      });
      return false;
    }

    return true;
  }

  Future<void> _getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;

    try {
      setState(() {
        _isLoading = true;
        _locationMessage = '...';
      });

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 5));
      print(position);
      // تحديث الموقع في قاعدة البيانات
      final newLocation = CurrentLocation(
        id: _currentLocation.id,
        latitude: position.latitude,
        longitude: position.longitude,
        city: _currentLocation.city,
        country: _currentLocation.country,
      );

      await _locationDao.updateCurrentLocation(newLocation);

      setState(() {
        _currentLocation = newLocation;
        _locationMessage = '';
        _isLoading = false;
      });
    } catch (e) {
      print('خطأ في الحصول على الموقع: $e');
      setState(() {
        _locationMessage = 'فشل في الحصول على الموقع: $e';
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في الحصول على الموقع: $e'),
            action: SnackBarAction(
              label: 'إعادة المحاولة',
              onPressed: _getCurrentLocation,
            ),
          ),
        );
      }
    }
  }

  Future<void> _loadSettings() async {
    try {
      setState(() => _isLoading = true);

      final settings = await _settingsService.getSettings();

      final location = await _locationDao.getCurrentLocation();

      if (mounted) {
        setState(() {
          _settings = settings;
          _currentLocation = location;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('خطأ في تحميل الإعدادات: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ في تحميل الإعدادات: $e')));
      }
    }
  }

  Future<void> _saveSettings() async {
    try {
      await _settingsService.saveSettings(_settings);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم حفظ الإعدادات بنجاح')));
      }
    } catch (e) {
      print('خطأ في حفظ الإعدادات: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ في حفظ الإعدادات: $e')));
      }
    }
  }

  Future<void> _updateLocation(
      String city, String country, double latitude, double longitude) async {
    try {
      final newLocation = CurrentLocation(
        id: _currentLocation.id,
        city: city,
        country: country,
        latitude: latitude,
        longitude: longitude,
      );

      await _locationDao.updateCurrentLocation(newLocation);

      if (mounted) {
        setState(() {
          _currentLocation = newLocation;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث الموقع بنجاح')),
        );
      }
    } catch (e) {
      print('خطأ في تحديث الموقع: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء تحديث الموقع: $e')),
        );
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('لا يمكن فتح الرابط')));
        }
      }
    } catch (e) {
      print('خطأ في فتح الرابط: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ في فتح الرابط: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'الاعدادات'),
                    Tab(text: 'عن التطبيق'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [_buildSettingsTab(), _buildAboutTab()],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Column(
            children: [
              /* SwitchListTile(
                title: const Text(
                  'تفعيل الإشعارات',
                  textDirection: TextDirection.rtl,
                ),
                subtitle: const Text(
                  'استلام إشعارات للصلوات والأذكار',
                  textDirection: TextDirection.rtl,
                ),
                value: _settings.notificationsEnabled,
                onChanged: (value) async {
                  setState(() {
                    _settings = _settings.copyWith(notificationsEnabled: value);
                  });
                  await _saveSettings();
                },
              ),*/
              const Divider(),
              _buildLocationCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCard() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الموقع الحالي',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: _showLocationEditDialog,
                      tooltip: 'تعديل الموقع',
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _getCurrentLocation,
                      tooltip: 'تحديث الموقع',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_locationMessage.isNotEmpty)
              Text(_locationMessage)
            else ...[
              Text('المدينة: ${_currentLocation.city}'),
              Text('الدولة: ${_currentLocation.country}'),
              Text('خط العرض: ${_currentLocation.latitude}'),
              Text('خط الطول: ${_currentLocation.longitude}'),
            ],
          ],
        ),
      ),
    );
  }

  void _showLocationEditDialog() {
    final cityController = TextEditingController(text: _currentLocation.city);
    final countryController =
        TextEditingController(text: _currentLocation.country);
    final latitudeController =
        TextEditingController(text: _currentLocation.latitude.toString());
    final longitudeController =
        TextEditingController(text: _currentLocation.longitude.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل معلومات الموقع'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'المدينة',
                  hintText: 'أدخل اسم المدينة',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: countryController,
                decoration: const InputDecoration(
                  labelText: 'الدولة',
                  hintText: 'أدخل اسم الدولة',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: latitudeController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'خط العرض',
                  hintText: 'أدخل قيمة خط العرض (مثال: 41.0082)',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: longitudeController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'خط الطول',
                  hintText: 'أدخل قيمة خط الطول (مثال: 28.9784)',
                ),
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
              try {
                final latitude = double.parse(latitudeController.text);
                final longitude = double.parse(longitudeController.text);

                if (latitude < -90 || latitude > 90) {
                  throw Exception('يجب أن يكون خط العرض بين -90 و 90');
                }
                if (longitude < -180 || longitude > 180) {
                  throw Exception('يجب أن يكون خط الطول بين -180 و 180');
                }

                _updateLocation(
                  cityController.text,
                  countryController.text,
                  latitude,
                  longitude,
                );
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('قيم الإحداثيات غير صالحة: $e')),
                );
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'عن التطبيق',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 16),
          const Text(
            'تطبيق إسلامي شامل يهدف إلى توفير أدوات وموارد مفيدة للمسلمين في حياتهم اليومية.',
            style: TextStyle(fontSize: 16),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 24),
          const Text(
            'رؤيتنا',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          const Text(
            'نسعى إلى تقديم محتوى إسلامي موثوق ومفيد يساعد المسلمين على تطبيق تعاليم دينهم في حياتهم اليومية.',
            style: TextStyle(fontSize: 16),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 24),
          const Text(
            'تواصل معنا',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('البريد الإلكتروني'),
            subtitle: const Text('engineerjafarasi@gmail.com'),
            onTap: () => _launchUrl('mailto:engineerjafarasi@gmail.com'),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('قم بدعم زاد المصلحين'),
            subtitle: const Text('يمكنك التطوع في زاد المصلحين'),
            onTap: () => _launchUrl(
                'https://docs.google.com/forms/d/e/1FAIpQLSdDREoJNZF1J-qr9ETHfnm6rnHYLuTxWtZtF4wpoS2NCfmnlw/viewform'),
          ),
          const SizedBox(height: 24),
          const Text(
            'تابعنا',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.play_circle_filled,
                    color: Colors.red,
                  ),
                  title: const Text('يوتيوب'),
                  subtitle: const Text('@zadulmuslihin'),
                  onTap: () => _launchUrl('https://youtube.com/@zadulmuslihin'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Colors.pink),
                  title: const Text('انستغرام'),
                  subtitle: const Text('@zadalmoslihin'),
                  onTap: () =>
                      _launchUrl('https://www.instagram.com/zadalmoslihin/'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.telegram, color: Colors.blue),
                  title: const Text('تلغرام'),
                  subtitle: const Text('@makeenjeel'),
                  onTap: () => _launchUrl('https://t.me/makeenjeel'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.music_note, color: Colors.black),
                  title: const Text('تيك توك'),
                  subtitle: const Text('@zadalmoslihin'),
                  onTap: () =>
                      _launchUrl('https://www.tiktok.com/@zadalmoslihin'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
