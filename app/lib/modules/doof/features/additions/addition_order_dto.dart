import 'package:decimal/decimal.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:mek_gasol/modules/doof/shared/serialization.dart';

part 'addition_order_dto.g.dart';

@DataClass()
@DtoSerializable()
class AdditionOrderDto with _$AdditionOrderDto {
  final String additionId;
  final String title;
  final String description;
  final Decimal price;

  const AdditionOrderDto({
    required this.additionId,
    required this.title,
    required this.description,
    required this.price,
  });

  factory AdditionOrderDto.fromJson(Map<String, dynamic> map) => _$AdditionOrderDtoFromJson(map);
  Map<String, dynamic> toJson() => _$AdditionOrderDtoToJson(this);
}
