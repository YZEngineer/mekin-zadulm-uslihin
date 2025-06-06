import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quran_model.dart';

class QuranService {
  static const String baseUrl = 'https://api.alquran.cloud/v1';

  Future<List<Surah>> getAllSurahs() async {
    try {
      print('Fetching all surahs...');
      final response = await http.get(Uri.parse('$baseUrl/surah'));
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> surahsData = data['data'];
        return surahsData.map((surah) => Surah.fromJson(surah)).toList();
      } else {
        throw Exception('Failed to load surahs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getAllSurahs: $e');
      throw Exception('Error loading surahs: $e');
    }
  }

  Future<Surah> getSurah(int surahNumber) async {
    try {
      print('Fetching surah $surahNumber...');
      final response = await http.get(
        Uri.parse('$baseUrl/surah/$surahNumber/ar.alafasy'),
      );
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Surah.fromJson(data['data']);
      } else {
        throw Exception('Failed to load surah: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getSurah: $e');
      throw Exception('Error loading surah: $e');
    }
  }
}
