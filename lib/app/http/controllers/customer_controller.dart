import 'package:paml_tugas_api/app/models/customer.dart';
import 'package:vania/vania.dart';

class CustomerController extends Controller {
  Future<Response> index() async {
    try {
      var results = await Customer()
          .query()
          .join('orders', 'customers.cust_id', '=', 'orders.cust_id')
          .join('orderitems', 'orders.order_num', '=', 'orderitems.order_num')
          .get();

      Map<String, dynamic> customerMap = {};

      for (var row in results) {
        String custId = row['cust_id'];

        if (!customerMap.containsKey(custId)) {
          customerMap[custId] = {
            'cust_id': row['cust_id'],
            'cust_name': row['cust_name'],
            'cust_address': row['cust_address'],
            'cust_city': row['cust_city'],
            'cust_zip': row['cust_zip'],
            'cust_country': row['cust_country'],
            'cust_telp': row['cust_telp'],
            'created_at': row['created_at'],
            'updated_at': row['updated_at'],
            'orders': []
          };
        }

        // Cek apakah order sudah ada dalam array orders
        String orderNum = row['order_num'].toString();
        var existingOrder = customerMap[custId]['orders'].firstWhere(
            (order) => order['order_num'].toString() == orderNum,
            orElse: () => null);

        if (existingOrder == null) {
          existingOrder = {
            'order_num': row['order_num'],
            'order_date': row['order_date'],
            'created_at': row['created_at'],
            'updated_at': row['updated_at'],
            'order_items': []
          };
          customerMap[custId]['orders'].add(existingOrder);
        }

        // Tambahkan order item ke order yang sesuai
        existingOrder['order_items'].add({
          'order_item': row['order_item'],
          'prod_id': row['prod_id'],
          'quantity': row['quantity'],
          'size': row['size'],
          'created_at': row['created_at'],
          'updated_at': row['updated_at'],
        });
      }

      return Response.json({
        'success': true,
        'message': 'Customers found',
        'data': customerMap.values.toList(),
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': 'Failed to get customers',
        'error': e.toString()
      });
    }
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      var name = request.input('name');
      var address = request.input('address');
      var kota = request.input('kota');
      var zip = request.input('zip');
      var country = request.input('country');
      var telp = request.input('telp');

      var custId = Customer().generateId();

      await Customer().query().insert({
        'cust_id': custId,
        'cust_name': name,
        'cust_address': address,
        'cust_city': kota,
        'cust_zip': zip,
        'cust_country': country,
        'cust_telp': telp,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      var customer =
          await Customer().query().where('cust_id', '=', custId).first();

      return Response.json({
        'success': true,
        'message': 'Customer created successfully',
        'data': customer
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': 'Failed to create customer',
        'error': e.toString()
      });
    }
  }

  Future<Response> show(String id) async {
    try {
      var customer = await Customer().query().where('cust_id', '=', id).first();

      if (customer == null) {
        return Response.json({
          'success': false,
          'message': 'Customer not found',
        });
      }

      return Response.json({
        'success': true,
        'message': 'Customer found',
        'data': customer,
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': 'Failed to get customer',
        'error': e.toString()
      });
    }
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, String id) async {
    try {
      var name = request.input('name');
      var address = request.input('address');
      var kota = request.input('kota');
      var zip = request.input('zip');
      var country = request.input('country');
      var telp = request.input('telp');

      await Customer().query().where('cust_id', '=', id).update({
        'cust_name': name,
        'cust_address': address,
        'cust_city': kota,
        'cust_zip': zip,
        'cust_country': country,
        'cust_telp': telp,
        'updated_at': DateTime.now().toIso8601String(),
      });

      var customer = await Customer().query().where('cust_id', '=', id).first();

      return Response.json({
        'success': true,
        'message': 'Customer updated successfully',
        'data': customer
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': 'Failed to update customer',
        'error': e.toString()
      });
    }
  }

  Future<Response> destroy(String id) async {
    try {
      var customer = await Customer().query().where('cust_id', '=', id).first();

      if (customer == null) {
        return Response.json({
          'success': false,
          'message': 'Customer not found',
        });
      }

      await Customer().query().where('cust_id', '=', id).delete();

      return Response.json({
        'success': true,
        'message': 'Customer deleted successfully',
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': 'Failed to delete customer',
        'error': e.toString()
      });
    }
  }
}

final CustomerController customerController = CustomerController();
