import 'package:paml_tugas_api/app/http/controllers/auth_controller.dart';
import 'package:paml_tugas_api/app/http/controllers/customer_controller.dart';
import 'package:paml_tugas_api/app/http/controllers/order_controller.dart';
import 'package:paml_tugas_api/app/http/controllers/product_controller.dart';
import 'package:paml_tugas_api/app/http/controllers/product_note_controller.dart';
import 'package:paml_tugas_api/app/http/controllers/vendor_controller.dart';
import 'package:paml_tugas_api/app/http/middleware/authenticate.dart';
import 'package:vania/vania.dart';
import 'package:paml_tugas_api/app/http/controllers/home_controller.dart';
import 'package:paml_tugas_api/app/http/middleware/home_middleware.dart';
import 'package:paml_tugas_api/app/http/middleware/error_response_middleware.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix
    Router.basePrefix('api');

    Router.get("/home", homeController.index);

    Router.get("/hello-world", () {
      return Response.html('Hello World');
    }).middleware([HomeMiddleware()]);

    // Return error code 400
    Router.get('wrong-request',
            () => Response.json({'message': 'Hi wrong request'}))
        .middleware([ErrorResponseMiddleware()]);

    Router.group(() {
      Router.post('/register', authController.register);
      Router.post('/login', authController.login);
      Router.post('/logout', authController.logout)
          .middleware([AuthenticateMiddleware()]);
    }, prefix: '/auth');

    Router.group(() {
      Router.group(() {
        Router.get('/', vendorController.index);
        Router.post('/', vendorController.store);
        Router.get('/{id}', vendorController.show);
        Router.put('/{id}', vendorController.update);
        Router.delete('/{id}', vendorController.destroy);
      }, prefix: '/vendors');

      Router.group(() {
        Router.get('/', customerController.index);
        Router.post('/', customerController.store);
        Router.get('/{id}', customerController.show);
        Router.put('/{id}', customerController.update);
        Router.delete('/{id}', customerController.destroy);
      }, prefix: '/customers');

      Router.group(() {
        Router.get('/', productController.index);
        Router.post('/', productController.store);
        Router.get('/{id}', productController.show);
        Router.put('/{id}', productController.update);
        Router.delete('/{id}', productController.destroy);
      }, prefix: '/products');

      Router.group(() {
        Router.get('/', productNoteController.index);
        Router.post('/', productNoteController.store);
        Router.get('/{id}', productNoteController.show);
        Router.put('/{id}', productNoteController.update);
        Router.delete('/{id}', productNoteController.destroy);
      }, prefix: '/product-notes');

      Router.group(() {
        Router.get('/', orderController.index);
        Router.post('/', orderController.store);
        Router.get('/{id}', orderController.show);
        Router.delete('/{id}', orderController.destroy);
      }, prefix: '/orders');
    }, middleware: [AuthenticateMiddleware()]);
  }
}
