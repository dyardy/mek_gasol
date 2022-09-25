import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/modules/auth/auth_guard.dart';
import 'package:mek_gasol/modules/doof/features/orders/screens/order_screen.dart';
import 'package:mek_gasol/modules/doof/features/orders/screens/orders_screen.dart';
import 'package:mek_gasol/modules/doof/features/products/screens/products_pick_screen.dart';
import 'package:mek_gasol/modules/doof/shared/doof_transaltions.dart';
import 'package:mek_gasol/shared/theme.dart';

/// Food app
class DoofApp extends StatelessWidget {
  const DoofApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      builder: (context, child) => MaterialApp(
        key: ValueKey(child),
        locale: const Locale.fromSubtags(languageCode: 'it'),
        localizationsDelegates: const [
          ...GlobalMaterialLocalizations.delegates,
          ValidationLocalizations(),
          DoofTranslations.delegate,
        ],
        supportedLocales: const [Locale.fromSubtags(languageCode: 'it')],
        debugShowCheckedModeBanner: false,
        title: 'Doof App',
        theme: AppTheme.build(),
        home: child ?? const _AuthenticatedArea(),
      ),
    );
  }
}

enum _Tab { orders, cart, products }

class _AuthenticatedArea extends StatefulWidget {
  const _AuthenticatedArea({Key? key}) : super(key: key);

  @override
  State<_AuthenticatedArea> createState() => _AuthenticatedAreaState();
}

class _AuthenticatedAreaState extends State<_AuthenticatedArea> {
  var _tab = _Tab.products;

  void changeTab(_Tab tab) {
    setState(() => _tab = tab);
  }

  @override
  Widget build(BuildContext context) {
    Widget buildTab(_Tab tab) {
      switch (tab) {
        case _Tab.orders:
          return const OrdersScreen();
        case _Tab.products:
          return const ProductsPickScreen();
        case _Tab.cart:
          return const CartScreen();
      }
    }

    BottomNavigationBarItem buildBottomBarItem(_Tab tab) {
      switch (tab) {
        case _Tab.orders:
          return const BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            label: 'Orders',
          );
        case _Tab.products:
          return const BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: 'Products',
          );
        case _Tab.cart:
          return const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          );
      }
    }

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab.index,
        onTap: (index) => changeTab(_Tab.values[index]),
        items: _Tab.values.map(buildBottomBarItem).toList(),
      ),
      body: IndexedStack(
        index: _tab.index,
        children: _Tab.values.map(buildTab).toList(),
      ),
    );
  }
}
