import '../../../routes/route_paths.dart';

extension BasePathExtensions on String {
  String get addBasePath {
    if (startsWith('/')) return this; // already correct
    return RoutePaths.basePath + this;
  }
}
