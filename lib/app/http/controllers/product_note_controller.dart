import 'package:paml_tugas_api/app/models/product.dart';
import 'package:paml_tugas_api/app/models/productnotes.dart';
import 'package:vania/vania.dart';

class ProductNoteController extends Controller {
  Future<Response> index() async {
    try {
      var results = await Productnotes()
          .query()
          .join('products', 'productnotes.prod_id', '=', 'products.prod_id')
          .select(['productnotes.*', 'products.prod_name']).get();

      return Response.json({
        'success': true,
        'message': 'Product Notes found',
        'data': results,
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': 'Failed to get product notes',
        'error': e.toString()
      });
    }
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      var productId = request.input('product_id');

      var isProductExist =
          await Product().query().where('prod_id', '=', productId).first();
      if (isProductExist == null) {
        return Response.json({
          'success': false,
          'message': 'Product not found',
        });
      }

      var noteDate = request.input('date');
      var noteText = request.input('text');

      var productNoteId = Productnotes().generateId();
      await Productnotes().query().insert({
        'note_id': productNoteId,
        'prod_id': isProductExist['prod_id'],
        'note_date': noteDate,
        'note_text': noteText,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      var productNote = await Productnotes()
          .query()
          .where('note_id', '=', productNoteId)
          .first();

      return Response.json({
        'success': true,
        'message': 'Product Note created successfully',
        'data': productNote
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': 'Failed to create product note',
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
      var existingProductNote =
          await Productnotes().query().where('note_id', '=', id).first();
      if (existingProductNote == null) {
        return Response.json({
          'success': false,
          'message': 'Product Note not found',
        });
      }

      var productId = request.input('product_id');
      if (productId != null && productId.isNotEmpty) {
        var isProductExist =
            await Product().query().where('prod_id', '=', productId).first();
        if (isProductExist == null) {
          return Response.json({
            'success': false,
            'message': 'Product not found',
          });
        }
      } else {
        productId = existingProductNote['prod_id'];
      }

      var noteDate = request.input('date');
      var noteText = request.input('text');
      await Productnotes().query().where('note_id', '=', id).update({
        'prod_id': productId,
        'note_date': noteDate,
        'note_text': noteText,
        'updated_at': DateTime.now().toIso8601String(),
      });

      var productNote =
          await Productnotes().query().where('note_id', '=', id).first();

      return Response.json({
        'success': true,
        'message': 'Product Note updated successfully',
        'data': productNote
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': 'Failed to update product note',
        'error': e.toString()
      });
    }
  }

  Future<Response> destroy(String id) async {
    try {
      var existingProductNote =
          await Productnotes().query().where('note_id', '=', id).first();
      if (existingProductNote == null) {
        return Response.json({
          'success': false,
          'message': 'Product Note not found',
        });
      }

      await Productnotes().query().where('note_id', '=', id).delete();

      return Response.json({
        'success': true,
        'message': 'Product Note deleted successfully',
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': 'Failed to delete product note',
        'error': e.toString()
      });
    }
  }
}

final ProductNoteController productNoteController = ProductNoteController();
