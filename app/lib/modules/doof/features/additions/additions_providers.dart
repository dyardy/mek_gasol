import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/doof/features/additions/repositories/additions_repository.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';

abstract class AdditionsProviders {
  static final all = StreamProvider.family((ref, String productId) {
    return get<AdditionsRepository>().watch(productId);
  });
}
