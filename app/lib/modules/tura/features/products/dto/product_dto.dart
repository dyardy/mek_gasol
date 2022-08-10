import 'package:decimal/decimal.dart';
import 'package:mek_adaptable/mek_adaptable.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'product_dto.g.dart';

@DataClass()
class ProductDto with _$ProductDto implements Adaptable {
  final String id;
  final String title;
  final String description;
  final Decimal price;

  const ProductDto({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
  });
}
