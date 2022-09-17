// import 'package:flutter/material.dart';
// import 'package:flutter_form_bloc/flutter_form_bloc.dart';
// import 'package:mek_gasol/modules/doof/features/orders/dvo/product_order_dvo.dart';
// import 'package:mek_gasol/modules/doof/features/products/dto/product_dto.dart';
// import 'package:mek_gasol/modules/doof/features/products/repositories/products_repository.dart';
// import 'package:mek_gasol/modules/doof/shared/blocs.dart';
// import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
// import 'package:mek_gasol/modules/doof/shared/widgets/bloc_widgets.dart';
// import 'package:reactive_forms/reactive_forms.dart';
//
// class OrderProductScreen extends StatefulWidget {
//   final OrderProductDvo? product;
//
//   const OrderProductScreen({
//     super.key,
//     this.product,
//   });
//
//   @override
//   State<OrderProductScreen> createState() => _OrderProductScreenState();
// }
//
// class _OrderProductScreenState extends State<OrderProductScreen> {
//   late final _products = QueryBloc(() {
//     return get<ProductsRepository>().watch();
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final product = widget.product;
//
//     Widget buildBody(BuildContext context, List<ProductDto> products) {
//       // return Column(
//       //   children: [
//       //     ReactiveFormField<ProductDto, ProductDto>(
//       //       builder: (state) {
//       //         return GroupView(
//       //           style: const TableGroupStyle(),
//       //           count: products.length,
//       //           builder: (context, index) {
//       //             final product = products[index];
//       //
//       //             return RadioListTile(
//       //               value: product,
//       //               groupValue: state.value,
//       //               onChanged: state.didChange,
//       //             );
//       //           },
//       //         );
//       //       },
//       //     ),
//       //   ],
//       // );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(product == null ? 'Add Product' : product.title),
//       ),
//       body: QueryViewBuilder(
//         bloc: _products,
//         builder: buildBody,
//       ),
//     );
//   }
// }
