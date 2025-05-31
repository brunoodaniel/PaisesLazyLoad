import 'package:flutter/material.dart';
import '../models/country_model.dart';

class CountryDetailScreen extends StatelessWidget {
  final Country country;

  const CountryDetailScreen({Key? key, required this.country}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          country.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A2980),
                Color(0xFF26D0CE),
              ],
            ),
          ),
        ),
        elevation: 8,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5F7FA),
              Color(0xFFE4E7EB),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      country.flag,
                      width: 250,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                        Container(
                          width: 250,
                          height: 150,
                          color: Colors.blueGrey,
                          child: const Icon(
                            Icons.flag,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildDetailCard(
                icon: Icons.location_city,
                label: 'Capital',
                value: country.capital,
              ),
              _buildDetailCard(
                icon: Icons.public,
                label: 'Região',
                value: '${country.region} (${country.subregion})',
              ),
              _buildDetailCard(
                icon: Icons.people,
                label: 'População',
                value: '${country.population.toString()} habitantes',
              ),
              _buildDetailCard(
                icon: Icons.language,
                label: 'Línguas',
                value: country.languages.join(', '),
              ),
              _buildDetailCard(
                icon: Icons.monetization_on,
                label: 'Moedas',
                value: country.currencies.join(', '),
              ),
              if (country.latlng != null && country.latlng!.length == 2)
                _buildDetailCard(
                  icon: Icons.map,
                  label: 'Coordenadas',
                  value: 'Lat: ${country.latlng![0]}, Lng: ${country.latlng![1]}',
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 28,
              color: const Color(0xFF1A2980),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}