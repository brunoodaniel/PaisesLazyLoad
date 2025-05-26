import 'package:flutter/material.dart';
import '../models/country_model.dart';

class CountryDetailScreen extends StatelessWidget {
  final Country country;

  const CountryDetailScreen({Key? key, required this.country}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(country.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                country.flag,
                width: 200,
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => 
                  const Icon(Icons.flag, size: 100),
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow('Capital', country.capital),
            _buildDetailRow('Região', '${country.region} (${country.subregion})'),
            _buildDetailRow('População', country.population.toString()),
            _buildDetailRow('Línguas', country.languages.join(', ')),
            _buildDetailRow('Moeda', country.currencies.join(', ')),
            if (country.latlng != null && country.latlng!.length == 2)
              _buildDetailRow('Coordenadas', 
                'Lat: ${country.latlng![0]}, Lng: ${country.latlng![1]}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}