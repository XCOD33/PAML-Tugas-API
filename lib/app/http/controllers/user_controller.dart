import 'package:paml_tugas_api/app/models/user.dart';
import 'package:vania/vania.dart';

class UserController extends Controller {
  Future<Response> index() async {
    return Response.json({'message': 'Hello World'});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      var name = request.input('name');
      var email = request.input('email');
      var password = request.input('password');

      if (name == null || email == null || password == null) {
        return Response.json({
          'success': false,
          'message': 'Name, email, and password are required',
        });
      }

      var isEmailExist =
          await User().query().where('email', '=', email).first();
      if (isEmailExist != null) {
        return Response.json({
          'success': false,
          'message': 'Email already exist',
        });
      }

      final passwordHashed = Hash().make(password);
      var user = await User().query().create({
        'name': name,
        'email': email,
        'password': passwordHashed,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      return Response.json({
        'success': true,
        'message': 'User created successfully',
        'data': user
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': 'Failed to create user',
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
    return Response.json({});
  }
}

final UserController userController = UserController();
