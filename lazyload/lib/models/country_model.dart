class Country {
  final String name;
  final String flag;
  final String capital;
  final int population;
  final String region;
  final String currency;

  Country({
    required this.name,
    required this.flag,
    required this.capital,
    required this.population,
    required this.region,
    required this.currency,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    String getCurrencyName(Map<String, dynamic>? currencies) {
      if (currencies == null || currencies.isEmpty) return 'N/A';
      final firstKey = currencies.keys.first;
      return currencies[firstKey]['name']?.toString() ?? 'N/A';
    }

    String getCapital(dynamic capitalData) {
      if (capitalData is List && capitalData.isNotEmpty) {
        return capitalData.first?.toString() ?? 'N/A';
      }
      return 'N/A';
    }

    String getFlag(Map<String, dynamic>? flags) {
      if (flags == null) return '';
      return flags['png']?.toString() ?? flags['svg']?.toString() ?? '';
    }

    return Country(
      name: json['name']?['common']?.toString() ?? 'Desconhecido',
      flag: getFlag(json['flags']),
      capital: getCapital(json['capital']),
      population: json['population'] is int ? json['population'] : 0,
      region: json['region']?.toString() ?? 'N/A',
      currency: getCurrencyName(json['currencies'] != null 
          ? Map<String, dynamic>.from(json['currencies']) 
          : null),
    );
  }
}