// // ignore_for_file: unused_local_variable
//
// import 'package:flutter/material.dart';
// import 'package:mek_gasol/modules/doof/features/additions/repositories/additions_repository.dart';
// import 'package:mek_gasol/modules/doof/features/products/dto/product_dto.dart';
// import 'package:mek_gasol/modules/doof/shared/blocs.dart';
// import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
// import 'package:mek_gasol/modules/doof/shared/widgets/bloc_widgets.dart';
//
// // WARN: This class is not implemented
// class AdditionsScreen extends StatefulWidget {
//   final ProductDto product;
//
//   const AdditionsScreen({
//     super.key,
//     required this.product,
//   });
//
//   @override
//   State<AdditionsScreen> createState() => _AdditionsScreenState();
// }
//
// class _AdditionsScreenState extends State<AdditionsScreen> {
//   final _additionsBloc = QueryBloc(() {
//     return get<AdditionsRepository>().watch();
//   });
//
//   @override
//   void dispose() {
//     _additionsBloc.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder(
//       bloc: _additionsBloc,
//       builder: (context, state) {
//         final additions = state.data;
//
//         return ReactiveCheckbox();
//       },
//     );
//   }
// }
