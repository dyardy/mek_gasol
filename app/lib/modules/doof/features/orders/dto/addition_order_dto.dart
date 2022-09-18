import 'package:mek_data_class/mek_data_class.dart';
import 'package:mek_gasol/modules/doof/features/additions/dto/addition_dto.dart';
import 'package:mek_gasol/modules/doof/shared/serialization.dart';

part 'addition_order_dto.g.dart';

@DataClass()
@DtoSerializable()
class AdditionOrderDto with _$AdditionOrderDto {
  final AdditionDto addition;

  const AdditionOrderDto({
    required this.addition,
  });

  String get displayableAddition => addition.title;

  factory AdditionOrderDto.fromJson(Map<String, dynamic> map) => _$AdditionOrderDtoFromJson(map);
  Map<String, dynamic> toJson() => _$AdditionOrderDtoToJson(this);
}
