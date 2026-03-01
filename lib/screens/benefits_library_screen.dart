import 'package:flutter/material.dart';
import '../services/theme_service.dart';
import '../models/benefit.dart';
import 'claim_engine_screen.dart';

class BenefitsLibraryScreen extends StatefulWidget {
  const BenefitsLibraryScreen({super.key});

  @override
  State<BenefitsLibraryScreen> createState() => _BenefitsLibraryScreenState();
}

class _BenefitsLibraryScreenState extends State<BenefitsLibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  
  // Mock data for demonstration
  final List<Benefit> _allBenefits = [
    Benefit(
      id: '1',
      providerName: 'Chase',
      cardName: 'Sapphire Reserve',
      perkName: 'Trip Delay Reimbursement',
      category: 'Travel',
      coverageAmount: 500,
      description: 'Up to $500 for expenses if your trip is delayed 6+ hours.',
    ),
    Benefit(
      id: '2',
      providerName: 'Verizon',
      cardName: 'Unlimited Ultimate',
      perkName: 'Cell Phone Protection',
      category: 'Phone',
      coverageAmount: 600,
      description: 'Get up to $600 per claim for theft or damage.',
    ),
    Benefit(
      id: '3',
      providerName: 'Amex',
      cardName: 'Gold Card',
      perkName: 'Purchase Protection',
      category: 'Retail',
      coverageAmount: 1000,
      description: 'Covers theft and damage for up to 90 days from purchase.',
    ),
  ];

  List<Benefit> get _filteredBenefits {
    return _allBenefits.where((b) {
      final matchesSearch = b.providerName.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          b.cardName.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          b.perkName.toLowerCase().contains(_searchController.text.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || b.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeService.slate900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Benefits Library',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryFilter(),
          Expanded(
            child: _buildResultsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search cards or benefits...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.white.withOpacity(0.3)),
          filled: true,
          fillColor: ThemeService.slate800,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final categories = ['All', 'Travel', 'Phone', 'Retail', 'Dining'];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? ThemeService.primary : ThemeService.slate800,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.white10,
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultsList() {
    if (_filteredBenefits.isEmpty) {
      return Center(
        child: Text(
          'No benefits found',
          style: TextStyle(color: Colors.white.withOpacity(0.5)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _filteredBenefits.length,
      itemBuilder: (context, index) {
        final benefit = _filteredBenefits[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildBenefitCard(benefit),
        );
      },
    );
  }

  Widget _buildBenefitCard(Benefit benefit) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: ThemeService.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                benefit.providerName,
                style: const TextStyle(
                  color: ThemeService.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  benefit.category,
                  style: const TextStyle(color: Colors.white60, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            benefit.perkName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            benefit.cardName,
            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${benefit.coverageAmount.toStringAsFixed(0)} Coverage',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClaimEngineScreen(benefit: benefit),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeService.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                ),
                child: const Text('Start Claim'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
