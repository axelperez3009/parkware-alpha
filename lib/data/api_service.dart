import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parkware/config/constants/environment.dart';

class ApiService {
  static Future<Map<String, dynamic>> getAllProducts() async {
    final String sanityProjectId = Environment.sanityApiProjectId;
    final String token = Environment.sanityApiToken;
    final String apiUrl = 'https://${sanityProjectId}.api.sanity.io/v1/data/query/production?query=*[_type == "product"]';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Error al obtener el producto');
    }
  }

  static Future<Map<String, dynamic>> getAllStores() async {
    final String sanityProjectId = Environment.sanityApiProjectId;
    final String dataset = Environment.sanityApiDataset;
    final String token = Environment.sanityApiToken;
    final String apiUrl = 'https://${sanityProjectId}.api.sanity.io/v1/data/query/${dataset}?query=*[_type == "store"]';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Error al obtener las tiendas');
    }
  }

  static Future<Map<String, dynamic>> getAllNews() async {
      final String sanityProjectId = Environment.sanityApiProjectId;
      final String dataset = Environment.sanityApiDataset;
      final String token = Environment.sanityApiToken;
      final String apiUrl = 'https://${sanityProjectId}.api.sanity.io/v1/data/query/${dataset}?query=*[_type == "news"]';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Error al obtener las noticias');
      }
    }

  static Future<Map<String, dynamic>> getDocumentById(String id) async {
    final String sanityProjectId = Environment.sanityApiProjectId;
    final String dataset = Environment.sanityApiDataset;
    final String token = Environment.sanityApiToken;
    final String apiUrl = 'https://${sanityProjectId}.api.sanity.io/v1/data/query/${dataset}?query=*[ _id == "${id}" ]';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Error al obtener el documento');
    }
  }

  static String getImageUrl(String ref) {
    String imageUrl = ref.replaceAll("-jpg", ".jpg").replaceAll("image-", "https://cdn.sanity.io/images/dnyl6kr0/production/");
    return imageUrl;
  }
}
