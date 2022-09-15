import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:mek_gasol/clients/firebase/timestamp_json_converter.dart';
import 'package:mek_gasol/modules/doof/features/products/dto/product_order_dto.dart';
import 'package:mek_gasol/modules/doof/shared/serialization.dart';

part 'order_dto.g.dart';

@DataClass()
@DtoSerializable()
class OrderDto with _$OrderDto {
  final String id;
  final DateTime createdAt;
  final List<ProductOrderDto> products;

  const OrderDto({
    required this.id,
    required this.createdAt,
    required this.products,
  });

  factory OrderDto.fromJson(Map<String, dynamic> map) => _$OrderDtoFromJson(map);
  Map<String, dynamic> toJson() => _$OrderDtoToJson(this);
}
