import 'dart:convert';

import 'package:http/http.dart' as http;

class AddressLocation {
  const AddressLocation({
    required this.displayName,
    required this.latitude,
    required this.longitude,
  });

  final String displayName;
  final double latitude;
  final double longitude;
}

class AddressSuggestionService {
  AddressSuggestionService({http.Client? client, String? geocodingBaseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = geocodingBaseUrl ??
            const String.fromEnvironment(
              'GEOCODING_BASE_URL',
              defaultValue: 'https://nominatim.openstreetmap.org',
            );

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

  static DateTime? _lastPublicRequest;
  static final Map<String, AddressLocation> _cache = {};

  final http.Client _client;
  final String _baseUrl;

  List<String> search(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return suggestions;

    return suggestions.where((suggestion) {
      final option = suggestion.toLowerCase();
      return option.contains(normalized) || normalized.contains(option);
    }).toList();
  }

  Future<AddressLocation?> searchLocation(String query) async {
    final normalized = query.trim();
    if (normalized.isEmpty) return null;
    final cacheKey = 'search:$_baseUrl:${normalized.toLowerCase()}';
    if (_cache[cacheKey] case final cached?) return cached;

    await _respectPublicRateLimit();
    final uri = Uri.parse('$_baseUrl/search').replace(
      queryParameters: {
        'q': normalized,
        'format': 'jsonv2',
        'limit': '1',
        'addressdetails': '1',
        'accept-language': 'es',
      },
    );
    final response = await _client
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 12));
    if (response.statusCode != 200) {
      throw AddressLookupException('Search failed (${response.statusCode}).');
    }
    final body = jsonDecode(response.body);
    if (body is! List || body.isEmpty || body.first is! Map) return null;
    final location = _parseLocation(body.first as Map);
    _cache[cacheKey] = location;
    return location;
  }

  Future<AddressLocation?> reverseLocation({
    required double latitude,
    required double longitude,
  }) async {
    final cacheKey =
        'reverse:$_baseUrl:${latitude.toStringAsFixed(5)},${longitude.toStringAsFixed(5)}';
    if (_cache[cacheKey] case final cached?) return cached;

    await _respectPublicRateLimit();
    final uri = Uri.parse('$_baseUrl/reverse').replace(
      queryParameters: {
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'format': 'jsonv2',
        'zoom': '18',
        'addressdetails': '1',
        'accept-language': 'es',
      },
    );
    final response = await _client
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 12));
    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw AddressLookupException(
        'Reverse lookup failed (${response.statusCode}).',
      );
    }
    final body = jsonDecode(response.body);
    if (body is! Map || body['display_name'] == null) return null;
    final location = _parseLocation(body);
    _cache[cacheKey] = location;
    return location;
  }

  AddressLocation _parseLocation(Map<dynamic, dynamic> value) {
    final latitude = double.tryParse('${value['lat']}');
    final longitude = double.tryParse('${value['lon']}');
    if (latitude == null || longitude == null) {
      throw const AddressLookupException('Location coordinates are invalid.');
    }
    return AddressLocation(
      displayName: '${value['display_name']}',
      latitude: latitude,
      longitude: longitude,
    );
  }

  Future<void> _respectPublicRateLimit() async {
    if (!_baseUrl.contains('nominatim.openstreetmap.org')) return;
    final lastRequest = _lastPublicRequest;
    if (lastRequest != null) {
      final remaining =
          const Duration(seconds: 1) - DateTime.now().difference(lastRequest);
      if (remaining > Duration.zero) await Future<void>.delayed(remaining);
    }
    _lastPublicRequest = DateTime.now();
  }

  static const _headers = {
    'User-Agent': '#YoSoyConstiMix/0.1',
    'Accept': 'application/json',
  };
}

class AddressLookupException implements Exception {
  const AddressLookupException(this.message);

  final String message;

  @override
  String toString() => message;
}
