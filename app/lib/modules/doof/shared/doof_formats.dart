import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class DoofFormats {
  final String languageCode;

  static const LocalizationsDelegate<DoofFormats> delegate = _DoofTranslationsDelegate();

  const DoofFormats._({
    required this.languageCode,
  });

  static DoofFormats of(BuildContext context) => Localizations.of(context, DoofFormats)!;

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

class _DoofTranslationsDelegate extends LocalizationsDelegate<DoofFormats> {
  const _DoofTranslationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<DoofFormats> load(Locale locale) =>
      SynchronousFuture(DoofFormats._(languageCode: locale.languageCode));

  @override
  bool shouldReload(covariant LocalizationsDelegate<DoofFormats> old) => true;
}
