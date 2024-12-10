import 'package:paml_tugas_api/app/models/customer.dart';
import 'package:paml_tugas_api/app/models/orderitems.dart';
import 'package:paml_tugas_api/app/models/orders.dart';
import 'package:paml_tugas_api/app/models/product.dart';
import 'package:vania/vania.dart';

class OrderController extends Controller {
  Future<Response> index() async {
    try {
      var results = await Orders()
          .query()
          .join('orderitems', 'orders.order_num', '=', 'orderitems.order_num')
          .join('products', 'orderitems.prod_id', '=', 'products.prod_id')
          .join('customers', 'orders.cust_id', '=', 'customers.cust_id')
          .get();

      Map<String, dynamic> orderMap = {};

      for (var row in results) {
        int orderNum = row['order_num'];

        if (!orderMap.containsKey(orderNum)) {
          orderMap[orderNum.toString()] = {
            'order_num': row['order_num'],
            'order_date': row['order_date'],
            'customer_id': row['cust_id'],
            'customer_name': row['cust_name'], // dari join customers
            'created_at': row['created_at'],
            'updated_at': row['updated_at'],
            'order_items': []
          };
        }

        orderMap[orderNum.toString()]['order_items'].add({
          'order_item': row['order_item'],
          'product_id': row['prod_id'],
          'product_name': row['prod_name'], // dari join products
          'quantity': row['quantity'],
          'size': row['size'],
          'created_at': row['created_at'],
          'updated_at': row['updated_at'],
        });
      }

      return Response.json({
        'success': true,
        'message': 'Orders found',
        'data': orderMap.values.toList(),
      });
    } catch (e) {
      // log error message if any exception occurs
      print(e.toString());

      return Response.json({
        'success': false,
        'message': 'Failed to get orders',
        'error': e.toString()
      });
    }
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      // Get order date and customer ID from request
      var orderDate = request.input('order_date');
      var customerId = request.input('customer_id');

      // Check if customer exists in database
      var isCustomerExist =
          await Customer().query().where('cust_id', '=', customerId).first();
      if (isCustomerExist == null) {
        return Response.json({
          'success': false,
          'message': 'Customer not found',
        });
      }

      // Get order items from request and validate if not empty
      var orderItems = request.input('order_items') as List;
      if (orderItems.isEmpty) {
        return Response.json({
          'success': false,
          'message': 'Order items is empty',
        });
      }

      // Generate unique order number and create new order in database
      var orderNum = Orders().generateId();
      await Orders().query().insert({
        'order_num': orderNum,
        'order_date': orderDate,
        'cust_id': customerId,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Initialize list to store processed order items
      List<Map<String, dynamic>> savedOrderItems = [];

      // Process each item in the order
      for (var item in orderItems) {
        if (item is Map) {
          // Extract item details
          var prodId = item['prod_id'];
          var quantity = item['quantity'];
          var size = item['size'];

          // Validate item fields are not null
          if (prodId == null || quantity == null || size == null) {
            return Response.json({
              'success': false,
              'message': 'Order items is invalid',
            });
          }

          // Check if product exists in database
          var isProductExist =
              await Product().query().where('prod_id', '=', prodId).first();

          if (isProductExist == null) {
            return Response.json({
              'success': false,
              'message': 'Product not found',
            });
          }

          // Prepare order item data for database insertion
          var orderItemData = {
            'order_item': Orderitems().generateId(),
            'order_num': orderNum,
            'prod_id': isProductExist['prod_id'],
            'quantity': quantity,
            'size': size,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          };

          // Insert order item into database
          await Orderitems().query().insert(orderItemData);

          // Add processed item to saved items list
          savedOrderItems.add(orderItemData);
        }
      }

      // Return success response with order details
      return Response.json({
        'success': true,
        'message': 'Order created successfully',
        'data': {
          'orders':
              await Orders().query().where('order_num', '=', orderNum).first(),
          'order_items': savedOrderItems,
        }
      });
    } catch (e) {
      // Return error response if any exception occurs
      return Response.json({
        'success': false,
        'message': 'Failed to create order',
        'error': e.toString()
      });
    }
  }

  Future<Response> show(int id) async {
    return Response.json({});
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int id) async {
    return Response.json({});
  }

  Future<Response> destroy(int id) async {
    try {
      // Check if order exists in database
      var order = await Orders().query().where('order_num', '=', id).first();
      if (order == null) {
        return Response.json({
          'success': false,
          'message': 'Order not found',
        });
      }

      // Delete order items associated with the order
      await Orderitems().query().where('order_num', '=', id).delete();

      // Delete the order
      await Orders().query().where('order_num', '=', id).delete();

      // Return success response
      return Response.json({
        'success': true,
        'message': 'Order deleted successfully',
      });
    } catch (e) {
      // Return error response if any exception occurs
      return Response.json({
        'success': false,
        'message': 'Failed to delete order',
        'error': e.toString()
      });
    }
  }
}

final OrderController orderController = OrderController();
