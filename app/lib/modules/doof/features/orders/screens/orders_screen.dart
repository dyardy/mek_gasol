import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/orders_repository.dart';
import 'package:mek_gasol/modules/doof/features/orders/screens/order_screen.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/user_area.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';
import 'package:mek_gasol/shared/data/query_view_builder.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:mek_gasol/shared/widgets/sign_out_icon_button.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late final _orders = QueryBloc(() {
    return get<OrdersRepository>().watch();
  });

  @override
  void dispose() {
    _orders.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildBody(BuildContext context, List<OrderDto> orders) {
      if (orders.isEmpty) {
        return InfoView(
          onTap: () => get<ValueBloc<UserAreaTab>>().emit(UserAreaTab.cart),
          title: const Text('😰 Non hai ancora fatto nessun ordine! 😰\n🛒 Vai al carello! 🛒'),
        );
      }

      return ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];

          return ListTile(
            onTap: () => context.hub.push(OrderScreen(order: order)),
            title: Text('${order.createdAt}'),
            subtitle: Text('${order.status}'),
            trailing: PopupMenuButton(
              itemBuilder: (context) {
                return [
                  if (order.status == OrderStatus.draft)
                    PopupMenuItem(
                      onTap: () => get<OrdersRepository>().delete(order),
                      child: const ListTile(
                        title: Text('Delete'),
                        leading: Icon(Icons.delete),
                      ),
                    ),
                ];
              },
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: const SignOutIconButton(),
        title: const Text('Orders'),
      ),
      body: QueryViewBuilder(
        bloc: _orders,
        builder: buildBody,
      ),
    );
  }
}
