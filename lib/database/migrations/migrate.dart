import 'dart:io';
import 'package:vania/vania.dart';
import 'create_orderitems_table.dart';
import 'create_customers_table.dart';
import 'create_orders_table.dart';
import 'create_vendors_table.dart';
import 'create_products_table.dart';
import 'create_productnotes_table.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();
  if (args.isNotEmpty && args.first.toLowerCase() == "migrate:fresh") {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  registry() async {
    await CreateCustomersTable().up();
    await CreateVendorsTable().up();
    await CreateProductsTable().up();
    await CreateOrdersTable().up();
    await CreateOrderitemsTable().up();
    await CreateProductnotesTable().up();
    // await CreateUserTable().up();
  }

  dropTables() async {
    // await CreateUserTable().down();
    await CreateProductnotesTable().down();
    await CreateOrderitemsTable().down();
    await CreateOrdersTable().down();
    await CreateProductsTable().down();
    await CreateVendorsTable().down();
    await CreateCustomersTable().down();
  }
}
