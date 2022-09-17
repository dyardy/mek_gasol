import 'package:flutter/material.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/orders_repository.dart';
import 'package:mek_gasol/modules/doof/features/orders/screens/order_screen.dart';
import 'package:mek_gasol/modules/doof/shared/blocs.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/bloc_widgets.dart';
import 'package:mek_gasol/shared/hub.dart';

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
        title: const Text('Orders'),
        actions: [
          IconButton(
            onPressed: () => get<OrdersRepository>().create(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: QueryViewBuilder(
        bloc: _orders,
        builder: buildBody,
      ),
    );
  }
}
