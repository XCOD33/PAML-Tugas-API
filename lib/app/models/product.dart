import 'dart:math';

import 'package:vania/vania.dart';

class Product extends Model {
  Product() {
    super.table('products');
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
