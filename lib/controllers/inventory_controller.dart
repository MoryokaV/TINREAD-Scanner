import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tinread_scanner/models/inventory_model.dart';
import 'package:tinread_scanner/utils/api_exceptions.dart';
import 'package:tinread_scanner/utils/url_constants.dart';

class InventoryController {
  Future<List<Inventory>> fetchInventories() async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/itemService.svc?readyInventoryItemList"),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        final inventories = List<Inventory>.from(
          data['readyInventoryItemList'].map((inventoryJson) => Inventory.fromJson(inventoryJson)),
        );

        return inventories;
      } else {
        throw ServerException(response.statusCode);
      }
    } on Exception catch (_) {
      // SocketExceptions & ApiExceptions
      rethrow;
    }
  }
}
