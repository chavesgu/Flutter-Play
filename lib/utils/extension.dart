import 'package:intl/intl.dart';

extension Format on DateTime {
  String formatter([String? pattern]) {
    DateFormat formatter = DateFormat(pattern ?? 'yyyy-MM-dd');
    return formatter.format(this);
  }
}

extension stringtoint on String {
  int toInt() {
    return int.parse(this);
  }
}
