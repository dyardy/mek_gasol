import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/orders_providers.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/orders_repository.dart';
import 'package:mek_gasol/modules/doof/shared/navigation/routes.dart';
import 'package:mek_gasol/modules/doof/shared/riverpod.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/user_area.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';
import 'package:mek_gasol/shared/widgets/sign_out_icon_button.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildBody(BuildContext context, WidgetRef ref, List<OrderDto> orders) {
      if (orders.isEmpty) {
        return Consumer(builder: (context, ref, _) {
          return InfoView(
            onTap: () => ref.read(UserArea.tab.notifier).state = UserAreaTab.cart,
            title: const Text('😰 Non hai ancora fatto nessun ordine! 😰\n🛒 Vai al carello! 🛒'),
          );
        });
      }

      return ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];

          return ListTile(
            onTap: () => OrderRoute(order.id),
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
      body: AsyncViewBuilder(
        provider: OrdersProviders.sent,
        builder: buildBody,
      ),
    );
  }
}
