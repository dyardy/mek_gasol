import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/doof/features/categories/repositories/categories_repository.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';

abstract class CategoriesProviders {
  static final all = StreamProvider((ref) {
    return get<CategoriesRepository>().watch();
  });
}
