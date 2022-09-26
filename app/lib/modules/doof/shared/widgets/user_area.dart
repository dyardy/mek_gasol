import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/modules/doof/features/orders/screens/order_screen.dart';
import 'package:mek_gasol/modules/doof/features/orders/screens/orders_screen.dart';
import 'package:mek_gasol/modules/doof/features/products/screens/products_screen.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';

enum UserAreaTab { orders, cart, products }

class UserArea extends StatelessWidget {
  const UserArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buildTab(UserAreaTab tab) {
      switch (tab) {
        case UserAreaTab.orders:
          return const OrdersScreen();
        case UserAreaTab.products:
          return const ProductsScreen();
        case UserAreaTab.cart:
          return const CartScreen();
      }
    }

    BottomNavigationBarItem buildBottomBarItem(UserAreaTab tab) {
      switch (tab) {
        case UserAreaTab.orders:
          return const BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            label: 'Orders',
          );
        case UserAreaTab.products:
          return const BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: 'Menu',
          );
        case UserAreaTab.cart:
          return const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          );
      }
    }

    return BlocBuilder(
      bloc: get<ValueBloc<UserAreaTab>>(),
      builder: (context, tab) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tab.index,
            onTap: (index) => get<ValueBloc<UserAreaTab>>().emit(UserAreaTab.values[index]),
            items: UserAreaTab.values.map(buildBottomBarItem).toList(),
          ),
          body: IndexedStack(
            index: tab.index,
            children: UserAreaTab.values.map(buildTab).toList(),
          ),
        );
      },
    );
  }
}
