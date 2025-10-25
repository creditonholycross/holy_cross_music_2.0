import 'package:collection/collection.dart';

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  String capitalizeAll() {
    var sentanceSplit = this.split(' ');
    var modified = sentanceSplit.map(
      (v) => "${v[0].toUpperCase()}${v.substring(1)}",
    );
    return modified.join(' ');
  }
}
