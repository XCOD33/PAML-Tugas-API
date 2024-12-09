import 'dart:math';

import 'package:vania/vania.dart';

class Vendors extends Model {
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  Vendors() {
    super.table('vendors');
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }

  String generateId() {
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
      5,
      (_) => characters.codeUnitAt(random.nextInt(characters.length)),
    ));
  }
}
