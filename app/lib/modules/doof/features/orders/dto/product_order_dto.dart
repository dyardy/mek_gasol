import 'package:decimal/decimal.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:mek_gasol/features/users/dto/user_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/addition_order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/ingredient_order_dto.dart';
import 'package:mek_gasol/modules/doof/features/products/dto/product_dto.dart';
import 'package:mek_gasol/modules/doof/shared/serialization.dart';

part 'product_order_dto.g.dart';

@DataClass()
@DtoSerializable()
class ProductOrderDto with _$ProductOrderDto {
  final String id;
  final PublicUserDto user;
  final ProductDto product;
  final int quantity;
  final List<AdditionOrderDto> additions;
  final List<IngredientOrderDto> ingredients;

  const ProductOrderDto({
    required this.id,
    required this.user,
    required this.product,
    required this.quantity,
    required this.additions,
    required this.ingredients,
  });

  Decimal get total => additions.fold(product.price, (total, e) => total + e.addition.price);

  factory ProductOrderDto.fromJson(Map<String, dynamic> map) => _$ProductOrderDtoFromJson(map);
  Map<String, dynamic> toJson() => _$ProductOrderDtoToJson(this);
}
