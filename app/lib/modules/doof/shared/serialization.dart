import 'package:json_annotation/json_annotation.dart';

class DtoSerializable extends JsonSerializable {
  const DtoSerializable() : super();
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
