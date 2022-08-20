abstract class PersistenceService {
  Future<String?> getString(String key);
  Future<String> getStringDef(String key, String def);
  Future<String> getStringDefLazy(String key, String Function() def);

  Future<void> setString(String key, String value);
}
