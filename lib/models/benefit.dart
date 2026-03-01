import 'package:flutter/material.dart';

class Benefit {
  final String id;
  final String providerName;
  final String cardName;
  final String perkName;
  final String category;
  final double coverageAmount;
  final String description;

  Benefit({
    required this.id,
    required this.providerName,
    required this.cardName,
    required this.perkName,
    required this.category,
    required this.coverageAmount,
    required this.description,
  });

  factory Benefit.fromMap(Map<String, dynamic> map) {
    return Benefit(
      id: map['id'],
      providerName: map['provider_name'],
      cardName: map['card_carrier_name'],
      perkName: map['perk_name'],
      category: map['perk_category'],
      coverageAmount: (map['coverage_amount'] as num).toDouble(),
      description: map['description'] ?? '',
    );
  }
}

class UserBenefit {
  final String id;
  final Benefit benefit;
  final DateTime addedAt;

  UserBenefit({
    required this.id,
    required this.benefit,
    required this.addedAt,
  });
}
