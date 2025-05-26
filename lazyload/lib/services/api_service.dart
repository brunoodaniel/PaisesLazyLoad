import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country_model.dart';

class ApiService {
  static const String _baseUrl = 'https://restcountries.com/v3.1';
  static const int _itemsPerPage = 10;

  Future<List<Country>> getCountries(int page) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/all?fields=name,flags,capital,population,region,subregion,languages,currencies,latlng'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        // Paginação no cliente
        final startIndex = page * _itemsPerPage;
        final endIndex = startIndex + _itemsPerPage;
        
        if (startIndex >= data.length) {
          return [];
        }
        
        return data
            .sublist(startIndex, endIndex.clamp(0, data.length))
            .map((json) => Country.fromJson(json))
            .toList();
      } else {
        throw Exception('Falha ao carregar países: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Falha ao conectar com a API: $e');
    }
  }
}