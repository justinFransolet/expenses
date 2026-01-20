import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

/// Service to fetch currency exchange rates.
class CurrencyService {
  static const String _baseUrl = 'api.frankfurter.dev';

  /// Fetches the conversion rate from [base] (e.g., 'EUR') to [target] (e.g., 'USD').
  /// If problems occur, returns 0.0.
  static Future<double> getExchangeRate(String base, String target) async {
    // Same currency, no conversion needed
    if (base.toUpperCase() == target.toUpperCase()) return 1.0;

    // Get the exchange rate from the API
    final uri = Uri.https(_baseUrl, '/v1/latest', {
      'base': base.toUpperCase(),
    });

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 5));
      // Check for HTTP errors
      if (response.statusCode != 200) {
        debugPrint('CurrencyService: HTTP ${response.statusCode}');
        return 0.0;
      }

      // Parse the JSON response
      final Map<String, dynamic> jsonBody = json.decode(response.body) as Map<String, dynamic>;
      final rates = jsonBody['rates'] as Map<String, dynamic>?;

      if (rates != null && rates.containsKey(target.toUpperCase())) {
        final value = rates[target.toUpperCase()];
        if (value is num) return value.toDouble();
        if (value is String) return double.tryParse(value) ?? 0.0;
      }

      debugPrint('CurrencyService: unexpected response body: ${response.body}');
    } catch (e, st) {
      debugPrint('CurrencyService error: $e\n$st');
    }

    return 0.0;
  }
}
