import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tinread_scanner/models/user_model.dart';
import 'package:tinread_scanner/utils/api_exceptions.dart';

class UserController {
  Future<void> login(User user) async {
    try {
      final response = await http.post(
        Uri.parse("${user.serverURL}/itemService.svc?auth&username=${user.username}&password=${user.password}"),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        if (data['info'] == "authenticated") {
          return;
        } else {
          throw UnauthorizedException();
        }
      } else {
        throw ServerException(response.statusCode);
      }
    } on Exception catch (_) {
      // SockerExceptions & ApiExceptions
      rethrow;
    }
  }
}
