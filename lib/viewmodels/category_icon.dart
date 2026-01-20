
import 'package:expenses/models/category.dart';
import 'package:flutter/material.dart';

extension CategoryIcon on Category {
  /// The icon to display in the UI
  IconData get icon {
    switch (this) {
      case Category.food: return Icons.restaurant;
      case Category.transport: return Icons.directions_bus;
      case Category.fun: return Icons.celebration;
      case Category.bills: return Icons.receipt_long;
    }
  }
}
