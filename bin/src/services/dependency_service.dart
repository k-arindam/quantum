class DependencyService {
  static final Map<String, dynamic> _runtimeDependencies = {};

  static T put<T>(T dependency, {required String tag}) {
    _runtimeDependencies[tag] = dependency;
    return dependency;
  }

  static Future<T> asyncPut<T>(T dependency, {required String tag}) async {
    _runtimeDependencies[tag] = dependency;
    return dependency;
  }

  static T find<T>(String tag) {
    final dependency = _runtimeDependencies[tag];

    if (dependency != null && dependency is T) {
      return dependency;
    }

    throw Exception('Dependency not injected !!!');
  }

  static bool isInjected(String tag) => _runtimeDependencies.containsKey(tag);

  Map<String, dynamic> get runtimeDependencies => _runtimeDependencies;
}
