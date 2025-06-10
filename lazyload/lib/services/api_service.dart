import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/country_model.dart';

class ApiService {
  static const String _baseUrl = 'https://restcountries.com/v3.1';

  Future<List<Country>> getCountries() async {
    print('Iniciando requisição para a API...');
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/all?fields=name,capital,flags,population,region,currencies'),
      ).timeout(const Duration(seconds: 60));

      print('Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        try {
          final List<dynamic> data = json.decode(response.body);
          if (data.isEmpty) {
            throw Exception('A API retornou uma lista vazia de países');
          }
          return data.map((json) => Country.fromJson(json)).toList()
            ..sort((a, b) => a.name.compareTo(b.name));
        } catch (e) {
          print('Erro ao processar resposta: $e');
          throw Exception('Erro ao processar dados da API');
        }
      } else {
        throw Exception('Erro na API: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      print('SocketException: $e');
      throw Exception('Sem conexão com a internet');
    } on TimeoutException catch (e) {
      print('TimeoutException: $e');
      throw Exception('Tempo de conexão esgotado');
    } on FormatException catch (e) {
      print('FormatException: $e');
      throw Exception('Formato de dados inválido da API');
    } catch (e) {
      print('Erro desconhecido: $e');
      throw Exception('Falha ao carregar países: $e');
    }
  }

  Future<Country?> buscarPaisPorNome(String name) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/name/$name?fields=name,capital,flags,population,region,currencies'),
      ).timeout(const Duration(seconds: 30));
      
      if (response.statusCode == 200) {
        try {
          final List<dynamic> data = json.decode(response.body);
          if (data.isNotEmpty) {
            return Country.fromJson(data.first);
          }
          throw CountryNotFoundException('País não encontrado');
        } catch (e) {
          throw Exception('Erro ao processar dados do país');
        }
      } else if (response.statusCode == 404) {
        throw CountryNotFoundException('País não encontrado');
      } else {
        throw Exception('Falha ao carregar país: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      throw Exception('Tempo de conexão esgotado');
    } catch (e) {
      if (e is CountryNotFoundException) {
        rethrow;
      }
      throw Exception('Falha ao conectar a API: $e');
    }
  }
}

class CountryNotFoundException implements Exception {
  final String message;
  CountryNotFoundException(this.message);
  
  @override
  String toString() => message;
}