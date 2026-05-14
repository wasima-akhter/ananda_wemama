import 'package:get/get.dart';

extension BindingExtension on GetInterface {
  void putPermanent<T>(T dependency) {
    put<T>(dependency, permanent: true);
  }

  void lazyPutFenix<T>(T Function() builder) {
    lazyPut<T>(builder, fenix: true);
  }
}
