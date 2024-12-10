import 'package:paml_tugas_api/app/models/product.dart';
import 'package:paml_tugas_api/app/models/vendors.dart';
import 'package:vania/vania.dart';

class ProductController extends Controller {
  Future<Response> index() async {
    try {
      var products = await Product().query().get();

      return Response.json({
        'success': true,
        'message': 'Products found',
        'data': products,
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': 'Failed to get products',
        'error': e.toString()
      });
    }
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      var vendorId = request.input('vendor_id');
      var name = request.input('name');
      var price = request.input('price');
      var desc = request.input('desc');

      var isVendorExist =
          await Vendors().query().where('vend_id', '=', vendorId).first();
      if (isVendorExist == null) {
        return Response.json({
          'success': false,
          'message': 'Vendor not found',
        });
      }

      var productId = Product().generateId();
      await Product().query().insert({
        'prod_id': productId,
        'vend_id': isVendorExist['vend_id'],
        'prod_name': name,
        'prod_price': price,
        'prod_desc': desc,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      var product =
          await Product().query().where('prod_id', '=', productId).first();

      return Response.json({
        'success': true,
        'message': 'Product created successfully',
        'data': product
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': 'Store product failed',
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

  Future<Response> update(Request request, String id) async {
    try {
      var product = await Product().query().where('prod_id', '=', id).first();

      if (product == null) {
        return Response.json({
          'success': false,
          'message': 'Product not found',
        });
      }

      var vendorId = request.input('vendor_id');
      if (vendorId != null && vendorId.isNotEmpty) {
        var isVendorExist =
            await Vendors().query().where('vend_id', '=', vendorId).first();
        if (isVendorExist == null) {
          return Response.json({
            'success': false,
            'message': 'Vendor not found',
          });
        }
      }

      var name = request.input('name');
      var price = request.input('price');
      var desc = request.input('desc');

      await Product().query().where('prod_id', '=', id).update({
        'vend_id': vendorId ?? product['vend_id'],
        'prod_name': name,
        'prod_price': price,
        'prod_desc': desc,
        'updated_at': DateTime.now().toIso8601String(),
      });

      var updatedProduct =
          await Product().query().where('prod_id', '=', id).first();

      return Response.json({
        'success': true,
        'message': 'Product updated successfully',
        'data': updatedProduct
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': 'Update product failed',
        'error': e.toString()
      });
    }
  }

  Future<Response> destroy(String id) async {
    try {
      var product = await Product().query().where('prod_id', '=', id).first();
      if (product == null) {
        return Response.json({
          'success': false,
          'message': 'Product not found',
        });
      }

      await Product().query().where('prod_id', '=', id).delete();

      return Response.json({
        'success': true,
        'message': 'Product deleted successfully',
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': 'Delete product failed',
        'error': e.toString()
      });
    }
  }
}

final ProductController productController = ProductController();
