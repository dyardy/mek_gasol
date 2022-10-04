import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mek_gasol/modules/doof/features/categories/dto/category_dto.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/packages/firestore.dart';
import 'package:mek_gasol/shared/env.dart';
import 'package:pure_extensions/pure_extensions.dart';

class CategoriesRepository {
  FirebaseFirestore get _firestore => get<FirebaseFirestore>();

  static const String collection = '${Env.prefix}categories';

  CollectionReference<CategoryDto> _ref() =>
      _firestore.collection(collection).withJsonConverter(CategoryDto.fromJson);

  Future<void> save(CategoryDto category) async {
    await _ref().doc(category.id.nullIfEmpty()).set(category);
  }

  Future<void> delete(CategoryDto category) async {
    await _ref().doc(category.id).delete();
  }

  Future<List<CategoryDto>> fetch() async {
    final snapshot = await _ref().get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  Stream<List<CategoryDto>> watch() {
    return _ref()
        .orderBy(CategoryDto.fields.title)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }
}
