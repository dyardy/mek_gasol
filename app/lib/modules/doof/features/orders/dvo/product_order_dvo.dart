import 'package:decimal/decimal.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:mek_gasol/features/users/dto/user_dto.dart';
import 'package:mek_gasol/modules/doof/features/additions/addition_order_dto.dart';

part 'product_order_dvo.g.dart';

@DataClass()
class ProductOrderDvo with _$ProductOrderDvo {
  final String id;
  final UserDto user;
  final String productId;
  final String title;
  final String description;
  final Decimal price;
  final int quantity;
  final List<AdditionOrderDto> additions;

  const ProductOrderDvo({
    required this.id,
    required this.user,
    required this.productId,
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
    required this.additions,
  });

  Decimal get total => additions.fold(price, (total, e) => total + e.price);
}
