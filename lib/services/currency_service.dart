import 'dart:convert';

import 'package:http/http.dart' as http;

/// Service to fetch currency exchange rates.
class CurrencyService {
  static const String _baseUrl = 'api.frankfurter.dev';

  /// Fetches the conversion rate from [base] (e.g., 'EUR') to [target] (e.g., 'USD').
  static Future<double> getExchangeRate(String base, String target) async {
    // TODO: implement fetching exchange rate from API if needed
    // Handle errors appropriately.
    return 1.0;
  }
}
