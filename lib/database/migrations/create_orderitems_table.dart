import 'package:vania/vania.dart';

class CreateOrderitemsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('orderitems', () {
      bigInt("order_item");
      primary("order_item");
      bigInt("order_num", length: 11);
      string("prod_id", length: 10);
      foreign("prod_id", "products", "prod_id",
          constrained: true, onDelete: "CASCADE");
      integer("quantity", defaultValue: 0);
      integer("size", defaultValue: 0);
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orderitems');
  }
}
