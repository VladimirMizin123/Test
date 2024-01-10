import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveSingleton {
  static HiveSingleton? _instance;
  late Box _myBox;

  factory HiveSingleton() {
    _instance ??= HiveSingleton._();
    return _instance!;
  }

  HiveSingleton._();

  Future<void> initHive() async {
    await Hive.initFlutter();
  }

  Future<void> openBox(String boxName) async {
    _myBox = await Hive.openBox(boxName);
  }

  Box get myBox => _myBox;

  Future<void> closeBox() async {
    await _myBox.close();
  }

  Future<void> clearBox() async {
    await _myBox.clear();
  }

  bool isBoxEmpty() {
    return _myBox.isEmpty;
  }

  Future<List<String>> getAllKeys() async {
    return _myBox.keys.cast<String>().toList();
  }

  Future<dynamic> getValueByKey(String key) async {
    return await _myBox.get(key);
  }

  Future<dynamic> addValueToBox(String key,dynamic value) async {
    // return await _myBox.get(key);
    await _myBox.put(key,value);
  }

  Future<String?> findKeysWithAnyWord(String searchKeyText) async{
    List<String> searchWords = searchKeyText.toLowerCase().split(' ');

    for (var key in _myBox.keys) {
      if (searchWords.every((word) => key.toLowerCase().contains(word))) {
        return key;  // Return the first matching key
      }
    }
    return null;  // Return null if no matching key is found
  }

}