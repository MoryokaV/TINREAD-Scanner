import 'package:http/http.dart' as http;
import 'package:tinread_scanner/utils/url_constants.dart';

// ignore: constant_identifier_names
const int PING_TIMEOUT_SECONDS = 3;

class ConnectivityService {
  Future<bool> checkApiConnection() async {
    try {
      final uri = Uri.parse(apiUrl);

      final response = await http.head(uri).timeout(
        const Duration(seconds: PING_TIMEOUT_SECONDS),
        onTimeout: () => http.Response('Timeout', 408),
      );

      return response.statusCode >= 200 && response.statusCode < 600;
    } catch (e) {
      return false;
    }
  }
}