import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazyload/models/country_model.dart';
import 'package:lazyload/widgets/country_card.dart';

void main() {
  final mockCountry = Country(
    name: 'Brasil',
    flag: 'https://flagcdn.com/br.svg',
    capital: 'Brasília',
    population: 213993437,
    region: 'Americas',
    currency: 'Real brasileiro',
  );

    group('Cenário 01 – Verificar se o nome do país é carregado no componente', () {
    testWidgets('Deve exibir o nome do país no card', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryCard(
              country: mockCountry,
              onTap: () {},
            ),
          ),
        ),
      );
      
      expect(find.text('Brasil'), findsOneWidget);
    });

    testWidgets('Deve exibir a capital do país no card', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryCard(
              country: mockCountry,
              onTap: () {},
            ),
          ),
        ),
      );

      //checa se a capital do país está sendo exibida
      expect(find.text('Brasília'), findsOneWidget);
    });
  });

  group('Cenário 02 – Verificar se ao clicar em um país os dados são abertos', () {
    testWidgets('Deve chamar onTap quando o card for pressionado', (WidgetTester tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryCard(
              country: mockCountry,
              onTap: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      //simula o toque no card
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(wasTapped, isTrue);
    });

    testWidgets('Deve ter feedback visual ao ser pressionado', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryCard(
              country: mockCountry,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(InkWell), findsOneWidget);
    });
  });

  group('Cenário 03 – Verificar se um componente de imagem é carregado com a bandeira', () {
    testWidgets('Deve exibir um componente de imagem para a bandeira', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryCard(
              country: mockCountry,
              onTap: () {},
            ),
          ),
        ),
      );

      //checa se a imagem está sendo exibida
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('Deve exibir um fallback quando a bandeira não carregar', (WidgetTester tester) async {
      final countryWithoutFlag = Country(
        name: 'Brasil',
        flag: '', 
        capital: 'Brasília',
        population: 213993437,
        region: 'Americas',
        currency: 'Real brasileiro',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryCard(
              country: countryWithoutFlag,
              onTap: () {},
            ),
          ),
        ),
      );

      //checa] se o ícone de fallback ta sendo exibido
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('Deve exibir a bandeira com o URL correto', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryCard(
              country: mockCountry,
              onTap: () {},
            ),
          ),
        ),
      );

      //checa se a imagem está sendo carregada com o URL correto
      final image = tester.widget<Image>(find.byType(Image));
      expect((image.image as NetworkImage).url, 'https://flagcdn.com/br.svg');
    });
  });

}