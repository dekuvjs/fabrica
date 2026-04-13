import 'package:intl/intl.dart';

final NumberFormat _currencyNumberFormat = NumberFormat('#,##0.00', 'en_US');

String formatCurrency(num value) => '\$${_currencyNumberFormat.format(value)}';
