import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/auth/auth_guard.dart';
import 'package:mek_gasol/modules/doof/features/orders/screens/orders_screen.dart';
import 'package:mek_gasol/modules/doof/features/products/screens/products_screen.dart';
import 'package:mek_gasol/modules/doof/shared/doof_transaltions.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';

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
          DoofTranslations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: const [Locale.fromSubtags(languageCode: 'it')],
        debugShowCheckedModeBanner: false,
        title: 'Doof App',
        theme: ThemeData.from(
          colorScheme: const ColorScheme.highContrastDark(primary: Colors.yellow),
        ),
        builder: (context, child) => MaterialMekProvider(child: child!),
        home: child ?? const _AuthenticatedArea(),
      ),
    );
  }
}

enum _Tab { orders, products }

final _tab = StateProvider((ref) => _Tab.orders);

class _AuthenticatedArea extends ConsumerWidget {
  const _AuthenticatedArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(_tab);

    Widget buildTab() {
      switch (tab) {
        case _Tab.orders:
          return const OrdersScreen();
        case _Tab.products:
          return const ProductsScreen();
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
            icon: Icon(Icons.bug_report_outlined),
            label: 'Products',
          );
      }
    }

    return Scaffold(
      body: buildTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab.index,
        onTap: (index) => ref.read(_tab.notifier).state = _Tab.values[index],
        items: _Tab.values.map(buildBottomBarItem).toList(),
      ),
    );
  }
}
