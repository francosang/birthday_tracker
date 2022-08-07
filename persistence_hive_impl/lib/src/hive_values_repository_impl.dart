import 'package:hive_flutter/hive_flutter.dart';
import 'package:lazy_evaluation/lazy_evaluation.dart';
import 'package:persistence/persistence.dart';

class HiveValuesRepositoryImpl implements ValuesRepository {
  final _box = Lazy<Future<Box>>(() async {
    await Hive.initFlutter();
    return Hive.openBox('testBox');
  });

  HiveValuesRepositoryImpl();

  @override
  Future<String?> getString(String key) async => (await _box.value).get(key);

  @override
  Future<String> getStringDef(String key, String def) async {
    final val = (await _box.value).get(key);
    return val ?? def;
  }

  @override
  Future<String> getStringDefLazy(String key, String Function() def) async {
    final val = (await _box.value).get(key);
    return val ?? def();
  }

  @override
  Future<void> setString(String key, String value) async {
    return (await _box.value).put(key, value);
  }
}
