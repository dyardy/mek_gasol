import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/modules/auth/auth_guard.dart';
import 'package:mek_gasol/modules/doof/features/orders/screens/orders_screen.dart';
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

// enum _Tab { orders, products }

class _AuthenticatedArea extends StatelessWidget {
  const _AuthenticatedArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Widget buildTab() {
    //   switch (_tab) {
    //     case _Tab.orders:
    //       return const OrdersScreen();
    //     case _Tab.products:
    //       return const ProductsScreen();
    //   }
    // }
    //
    // BottomNavigationBarItem buildBottomBarItem(_Tab tab) {
    //   switch (_tab) {
    //     case _Tab.orders:
    //       return const BottomNavigationBarItem(
    //         icon: Icon(Icons.library_books_outlined),
    //         label: 'Orders',
    //       );
    //     case _Tab.products:
    //       return const BottomNavigationBarItem(
    //         icon: Icon(Icons.bug_report_outlined),
    //         label: 'Products',
    //       );
    //   }
    // }

    return const OrdersScreen();

    // return Scaffold(
    //   body: buildTab(),
    //   bottomNavigationBar: BottomNavigationBar(
    //     currentIndex: tab.index,
    //     onTap: (index) => ref.read(_tab.notifier).state = _Tab.values[index],
    //     items: _Tab.values.map(buildBottomBarItem).toList(),
    //   ),
    // );
  }
}
