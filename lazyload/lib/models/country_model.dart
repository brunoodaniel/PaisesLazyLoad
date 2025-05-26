class Country {
  final String name;
  final String flag;
  final String capital;
  final int population;
  final String region;
  final String subregion;
  final List<String> languages;
  final List<String> currencies;
  final List<double>? latlng;

  Country({
    required this.name,
    required this.flag,
    required this.capital,
    required this.population,
    required this.region,
    required this.subregion,
    required this.languages,
    required this.currencies,
    this.latlng,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name']['common'] ?? 'Unknown',
      flag: json['flags']['png'] ?? '',
      capital: (json['capital'] as List?)?.first ?? 'N/A',
      population: json['population'] ?? 0,
      region: json['region'] ?? 'N/A',
      subregion: json['subregion'] ?? 'N/A',
      languages: (json['languages'] as Map?)?.values.cast<String>().toList() ?? [],
      currencies: (json['currencies'] as Map?)?.values.map((v) => v['name'].toString()).toList() ?? [],
      latlng: (json['latlng'] as List?)?.cast<double>(),
    );
  }
}