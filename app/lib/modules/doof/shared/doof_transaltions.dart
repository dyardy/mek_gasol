import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class DoofTranslations {
  final String languageCode;

  static const LocalizationsDelegate<DoofTranslations> delegate = _DoofTranslationsDelegate();

  const DoofTranslations._({
    required this.languageCode,
  });

  static DoofTranslations of(BuildContext context) => Localizations.of(context, DoofTranslations)!;

  String formatPrice(Decimal price) {
    return NumberFormat.compactSimpleCurrency(
      locale: languageCode,
      name: 'EUR',
    ).format(price.toDouble());
  }

  String formatDate(DateTime date) {
    return DateFormat.yMd(languageCode).format(date);
  }
}

class _DoofTranslationsDelegate extends LocalizationsDelegate<DoofTranslations> {
  const _DoofTranslationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<DoofTranslations> load(Locale locale) =>
      SynchronousFuture(DoofTranslations._(languageCode: locale.languageCode));

  @override
  bool shouldReload(covariant LocalizationsDelegate<DoofTranslations> old) => true;
}
