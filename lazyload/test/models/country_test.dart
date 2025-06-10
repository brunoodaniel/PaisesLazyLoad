import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazyload/models/country_model.dart';
import 'package:lazyload/services/api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'country_test.mocks.dart'; //arquivo q foi gerado pelo mockito

//gera mocks para as classes ApiService e http.Client
@GenerateMocks([ApiService, http.Client])
void main() {
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
  });

  //grupo de testes para cenário de listagem bem-sucedida
  group('Cenário 01 – Listagem bem-sucedida', () {
    final mockCountries = [
      Country(
        name: 'Estados Unidos',
        flag: 'https://flagcdn.com/us.svg',
        capital: 'Washington, D.C.',
        population: 331002651,
        region: 'Americas',
        currency: 'Dólar americano',
      ),
      Country(
        name: 'Canadá',
        flag: 'https://flagcdn.com/ca.svg',
        capital: 'Ottawa',
        population: 38005238,
        region: 'Americas',
        currency: 'Dólar canadense',
      ),
    ];

    //verifica se retorna lista não vazia
    test('Deve retornar lista de países não vazia', () async {
      when(mockApiService.getCountries())
          .thenAnswer((_) async => mockCountries);

      final result = await mockApiService.getCountries();

      // Verificações:
      expect(result, isNotEmpty); 
      verify(mockApiService.getCountries()).called(1);
    });

    //verifica os dados do primeiro país retornado
    test('Deve retornar o primeiro país correto com campos válidos', () async {
      when(mockApiService.getCountries())
          .thenAnswer((_) async => mockCountries);

      final result = await mockApiService.getCountries();
      final firstCountry = result.first;

      //verifica cada campo do primeiro país
      expect(firstCountry.name, 'Estados Unidos');
      expect(firstCountry.capital, 'Washington, D.C.');
      expect(firstCountry.flag, 'https://flagcdn.com/us.svg');
      expect(firstCountry.population, greaterThan(0)); 
      expect(firstCountry.currency, 'Dólar americano');
    });
  });

  //grupo de testes para cenários de erro na API
  group('Cenário 02 – Erro na requisição de países', () {
    test('Deve lançar exceção quando a API falha', () async {
      when(mockApiService.getCountries())
          .thenThrow(Exception('Erro na API'));

      expect(() => mockApiService.getCountries(), throwsException);
    });
  });

  //grupo de testes para busca por nome com resultado
  group('Cenário 03 – Busca de país por nome com resultado', () {
    final mockCountry = Country(
      name: 'França',
      flag: 'https://flagcdn.com/fr.svg',
      capital: 'Paris',
      population: 67391582,
      region: 'Europe',
      currency: 'Euro',
    );

    test('Deve retornar país não nulo com dados corretos', () async {
      when(mockApiService.buscarPaisPorNome('França'))
          .thenAnswer((_) async => mockCountry);

      final result = await mockApiService.buscarPaisPorNome('França');

      expect(result, isNotNull); 
      expect(result?.name, 'França');
      expect(result?.capital, 'Paris');
      expect(result?.population, 67391582);
      expect(result?.currency, 'Euro');
    });
  });

  //grupo de testes para busca por nome sem resultado
  group('Cenário 04 – Busca de país por nome com resultado vazio', () {
    test('Deve retornar null quando país não existe', () async {
      when(mockApiService.buscarPaisPorNome('Elbonia'))
          .thenAnswer((_) async => null);

      final result = await mockApiService.buscarPaisPorNome('Elbonia');
      expect(result, isNull); 
    });

    test('Deve lançar erro controlado quando país não existe', () async {
      when(mockApiService.buscarPaisPorNome('Elbonia'))
          .thenThrow(CountryNotFoundException('País não encontrado'));

      //verifica se a exceção específica é lançada
      expect(() => mockApiService.buscarPaisPorNome('Elbonia'),
          throwsA(isA<CountryNotFoundException>()));
    });
  });

  //grupo de testes para países com dados incompletos
  group('Cenário 05 – País com dados incompletos', () {
    test('Deve lidar com país sem capital', () async {
      final mockCountry = Country(
        name: 'Nauru',
        flag: 'https://flagcdn.com/nr.svg',
        capital: 'N/A', 
        population: 10834,
        region: 'Oceania',
        currency: 'Dólar australiano',
      );

      when(mockApiService.buscarPaisPorNome('Nauru'))
          .thenAnswer((_) async => mockCountry);

      final result = await mockApiService.buscarPaisPorNome('Nauru');
      expect(result?.capital, 'N/A'); 
    });

    test('Deve lidar com país sem bandeira', () async {
      final mockCountry = Country(
        name: 'Mônaco',
        flag: '', 
        capital: 'Monaco',
        population: 39244,
        region: 'Europe',
        currency: 'Euro',
      );

      when(mockApiService.buscarPaisPorNome('Mônaco'))
          .thenAnswer((_) async => mockCountry);

      final result = await mockApiService.buscarPaisPorNome('Mônaco');
      expect(result?.flag, isEmpty); 
    });

    test('Deve lidar com país sem moeda definida', () async {
      final mockCountry = Country(
        name: 'Palau',
        flag: 'https://flagcdn.com/pw.svg',
        capital: 'Ngerulmud',
        population: 18092,
        region: 'Oceania',
        currency: 'N/A', 
      );

      when(mockApiService.buscarPaisPorNome('Palau'))
          .thenAnswer((_) async => mockCountry);

      final result = await mockApiService.buscarPaisPorNome('Palau');
      expect(result?.currency, 'N/A'); 
    });
  });

  //grupo de testes para verificação de chamadas de métodos
  group('Cenário 06 – Verificar chamada ao método', () {
    test('Deve verificar se getCountries() foi chamado', () async {
      when(mockApiService.getCountries()).thenAnswer((_) async => []);

      await mockApiService.getCountries();
      verify(mockApiService.getCountries()).called(1);
    });

    test('Deve verificar se buscarPaisPorNome() foi chamado com parâmetro correto', () async {
      when(mockApiService.buscarPaisPorNome('Suíça')).thenAnswer((_) async => null);

      await mockApiService.buscarPaisPorNome('Suíça');
      //verifica se o método foi chamado com o parâmetro correto
      verify(mockApiService.buscarPaisPorNome('Suíça')).called(1);
    });
  });

  //grupo de testes para simular lentidão na API
  group('Cenário 07 – Simular lentidão da API', () {
    test('Deve lidar com atraso na resposta', () async {
      final mockCountries = [Country(
        name: 'Austrália',
        flag: 'https://flagcdn.com/au.svg',
        capital: 'Canberra',
        population: 25687041,
        region: 'Oceania',
        currency: 'Dólar australiano',
      )];

      when(mockApiService.getCountries()).thenAnswer((_) async {
        await Future.delayed(Duration(seconds: 2));
        return mockCountries;
      });

      final future = mockApiService.getCountries();

      expect(future, isA<Future<List<Country>>>());
      
      final result = await future;
      expect(result, isNotEmpty);
    });
  });

  //grupo de testes para múltiplas chamadas com parâmetros diferentes
  group('Cenário 08 – Múltiplas chamadas com parâmetros diferentes', () {
    test('Deve lidar com diferentes buscas por nome', () async {
      final mockItaly = Country(
        name: 'Itália',
        flag: 'https://flagcdn.com/it.svg',
        capital: 'Roma',
        population: 59554023,
        region: 'Europe',
        currency: 'Euro',
      );
      
      final mockJapan = Country(
        name: 'Japão',
        flag: 'https://flagcdn.com/jp.svg',
        capital: 'Tóquio',
        population: 125836021,
        region: 'Asia',
        currency: 'Yen',
      );

      when(mockApiService.buscarPaisPorNome('Itália')).thenAnswer((_) async => mockItaly);
      when(mockApiService.buscarPaisPorNome('Japão')).thenAnswer((_) async => mockJapan);

      final italy = await mockApiService.buscarPaisPorNome('Itália');
      final japan = await mockApiService.buscarPaisPorNome('Japão');

      expect(italy?.name, 'Itália');
      expect(japan?.name, 'Japão');
      
      verifyInOrder([
        mockApiService.buscarPaisPorNome('Itália'),
        mockApiService.buscarPaisPorNome('Japão'),
      ]);
    });
  });

  //grupo de testes para filtragem de países
  group('Cenário 09 – Filtragem de países', () {
    test('Deve filtrar países por região', () async {
      final mockCountries = [
        Country(
          name: 'Estados Unidos',
          flag: 'https://flagcdn.com/us.svg',
          capital: 'Washington, D.C.',
          population: 331002651,
          region: 'Americas',
          currency: 'Dólar americano'),
        Country(
          name: 'Canadá',
          flag: 'https://flagcdn.com/ca.svg',
          capital: 'Ottawa',
          population: 38005238,
          region: 'Americas',
          currency: 'Dólar canadense'),
        Country(
          name: 'Japão',
          flag: 'https://flagcdn.com/jp.svg',
          capital: 'Tóquio',
          population: 125836021,
          region: 'Asia',
          currency: 'Yen'),
      ];

      when(mockApiService.getCountries()).thenAnswer((_) async => mockCountries);

      final result = await mockApiService.getCountries();
      final americasCountries = result.where((c) => c.region == 'Americas').toList();

      expect(americasCountries, hasLength(2));
      expect(americasCountries[0].name, 'Estados Unidos');
      expect(americasCountries[1].name, 'Canadá');
    });
  });
}