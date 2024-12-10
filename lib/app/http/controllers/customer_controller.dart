import 'package:paml_tugas_api/app/models/customer.dart';
import 'package:vania/vania.dart';

class CustomerController extends Controller {
  Future<Response> index() async {
    try {
      var customers = await Customer().query().get();

      return Response.json({
        'success': true,
        'message': 'Customers found',
        'data': customers,
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
