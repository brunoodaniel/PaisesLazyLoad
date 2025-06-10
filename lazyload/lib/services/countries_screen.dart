import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/country_model.dart';
import '../widgets/country_card.dart';
import 'country_detail_screen.dart';

class CountriesScreen extends StatefulWidget {
  @override
  _CountriesScreenState createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  final ApiService _apiService = ApiService();
  List<Country> _countries = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    try {
      final countries = await _apiService.getCountries();
      setState(() {
        _countries = countries;
        _isLoading = false;
        _errorMessage = null;
      });
    } on Exception catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
        _countries = [];
      });
    }
  }

  Future<void> _refreshCountries() async {
    setState(() {
      _isLoading = true;
    });
    await _loadCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Países do Mundo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            shadows: [
              Shadow(
                blurRadius: 2.0,
                color: Colors.black26,
              )
            ],
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 77, 102, 241),
                Color.fromARGB(255, 77, 102, 241),
              ],
            ),
          ),
        ),
        elevation: 10,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshCountries,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
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
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _refreshCountries,
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshCountries,
                  child: ListView.builder(
                    itemCount: _countries.length,
                    itemBuilder: (context, index) {
                      return CountryCard(
                        country: _countries[index],
                        onTap: () => _navigateToDetail(context, _countries[index]),
                      );
                    },
                  ),
                ),
    );
  }

  void _navigateToDetail(BuildContext context, Country country) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountryDetailScreen(country: country),
      ),
    );
  }
}