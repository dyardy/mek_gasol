import 'package:json_annotation/json_annotation.dart';
import 'package:mek_gasol/clients/firebase/timestamp_json_converter.dart';

export 'package:json_annotation/json_annotation.dart' show $enumDecode;

class DtoSerializable extends JsonSerializable {
  const DtoSerializable() : super(converters: const [TimestampJsonConvert()]);
}

// class DecimalConverter extends JsonConverter<Decimal, String> {
//   const DecimalConverter();
//
//   @override
//   Decimal fromJson(String json) => Decimal.parse(json);
//
//   @override
//   String toJson(Decimal object) => object.toString();
// }
