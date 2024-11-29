import 'dart:convert';
import 'dart:io';

class TestDataLoader {
  static Future<List<Map<String, dynamic>>> loadOhlcv() async {
    final file = File('test/ohlcv.json');
    return List<Map<String, dynamic>>.from(jsonDecode(await file.readAsString()));
  }

  static Future<List<dynamic>> loadExpectedValues(String fileName) async {
    final file = File('test/data/$fileName');
    return jsonDecode(await file.readAsString());
  }
}
