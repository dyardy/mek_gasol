import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/product_order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/orders_repository.dart';
import 'package:mek_gasol/modules/doof/shared/k_doof.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:url_launcher/url_launcher.dart';

class SendOrderDialog extends StatefulWidget {
  final OrderDto order;
  final List<ProductOrderDto> products;

  const SendOrderDialog({
    super.key,
    required this.order,
    required this.products,
  });

  @override
  State<SendOrderDialog> createState() => _SendOrderDialogState();
}

class _SendOrderDialogState extends State<SendOrderDialog> {
  final _sendMb = MutationBloc();

  void _send(String message) {
    _sendMb.handle(() async {
      await launchUrl(Uri.https('wa.me', KDoof.woktimePhoneNumber, {'text': message}));
      await get<OrdersRepository>().update(widget.order, status: OrderStatus.sent);
    });
  }

  String _generateMessage() {
    const header = "Ciao volevo fare un ordine per domani alle 13.10 nome Kuama.\n";

    final products = widget.products;
    final body = products.map(_getDisplayableOrder).join('\n\n');

    const conclusion = "Grazie mille :-)";

    return '$header\n$body\n\n$conclusion';
  }

  String _getDisplayableOrder(ProductOrderDto productOrder) {
    final b = StringBuffer('-${productOrder.quantity}x ${productOrder.product.title}');

    // Ingredients
    b.writeAll(productOrder.ingredients.where((value) {
      return value.value != 0;
    }).map((orderIngredient) {
      return '${orderIngredient.ingredient.title} ${orderIngredient.effectiveValue}';
    }).map((e) => ', $e'));

    // Additions
    b.writeAll(productOrder.additions.map((orderAddition) {
      return orderAddition.addition.title;
    }).map((e) {
      return ', $e';
    }));

    return b.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final message = _generateMessage();

    Widget current = AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 20.0, bottom: 0.0),
      title: const Text("Conferma invio ordine"),
      content: Column(
        children: [
          Text(message, style: const TextStyle(fontStyle: FontStyle.italic)),
          const SizedBox(height: 24.0),
          Text("L'invio dell'ordine non permetterà altre modifiche.", style: textTheme.caption),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.hub.pop(),
          child: const Text('Anulla'),
        ),
        ButtonBuilder(
          onPressed: () => _send(message),
          mutationBlocs: {_sendMb},
          builder: (context, onPressed) {
            return ElevatedButton(
              onPressed: onPressed,
              child: const Text('Invia'),
            );
          },
        ),
      ],
    );
    current = BlocListener(
      bloc: _sendMb,
      listener: (context, state) => state.whenOrNull(success: (_) {
        context.hub
          ..pop()
          ..pop();
      }),
      child: current,
    );
    return current;
  }
}
