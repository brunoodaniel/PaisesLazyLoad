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
  final ScrollController _scrollController = ScrollController();
  final List<Country> _countries = [];
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadMoreCountries();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadMoreCountries();
    }
  }

  Future<void> _loadMoreCountries() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    try {
      final newCountries = await _apiService.getCountries(_currentPage);
      
      setState(() {
        _isLoading = false;
        if (newCountries.isEmpty) {
          _hasMore = false;
        } else {
          _countries.addAll(newCountries);
          _currentPage++;
        }
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar países: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Países'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _countries.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _countries.length) {
                  return CountryCard(
                    country: _countries[index],
                    onTap: () => _navigateToDetail(context, _countries[index]),
                  );
                } else {
                  return _buildProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: _isLoading 
            ? const CircularProgressIndicator()
            : const Text('No more countries to load'),
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