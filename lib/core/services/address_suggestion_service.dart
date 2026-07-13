class AddressSuggestionService {
  static const schoolAddress =
      'Av. 20 de noviembre #360 Colonia Modelo C.P. 91040 Xalapa, Veracruz';

  static const suggestions = [
    schoolAddress,
    'Mexico City, CDMX',
    'Toluca, Estado de Mexico',
    'Ecatepec, Estado de Mexico',
    'Guadalajara, Jalisco',
    'Monterrey, Nuevo Leon',
    'Puebla, Puebla',
    'Queretaro, Queretaro',
    'Morelia, Michoacan',
    'Xalapa, Veracruz',
    'Veracruz, Veracruz',
  ];

  List<String> search(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return suggestions;

    return suggestions.where((suggestion) {
      final option = suggestion.toLowerCase();
      return option.contains(normalized) || normalized.contains(option);
    }).toList();
  }
}
