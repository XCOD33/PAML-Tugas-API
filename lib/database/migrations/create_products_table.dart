import 'package:vania/vania.dart';

class CreateProductsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('products', () {
      string("prod_id", length: 10);
      primary("prod_id");
      char("vend_id", length: 11);
      foreign("vend_id", "vendors", "vend_id",
          constrained: true, onDelete: "CASCADE");
      string("prod_name", length: 25);
      bigInt("prod_price", defaultValue: 0, length: 15);
      text("prod_desc");
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('products');
  }
}
