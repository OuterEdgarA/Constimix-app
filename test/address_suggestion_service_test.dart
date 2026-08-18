import 'package:constimix_app/core/services/address_suggestion_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('address search uses the configured geocoder and identifies the app',
      () async {
    late http.Request captured;
    final service = AddressSuggestionService(
      geocodingBaseUrl: 'https://geo.example.test',
      client: MockClient((request) async {
        captured = request;
        return http.Response(
          '[{"display_name":"Xalapa, Veracruz, Mexico",'
          '"lat":"19.5438","lon":"-96.9102"}]',
          200,
        );
      }),
    );

    final result = await service.searchLocation('Xalapa');

    expect(captured.url.path, '/search');
    expect(captured.url.queryParameters['q'], 'Xalapa');
    expect(captured.headers['User-Agent'], '#YoSoyConstiMix/0.1');
    expect(result?.displayName, 'Xalapa, Veracruz, Mexico');
    expect(result?.latitude, 19.5438);
    expect(result?.longitude, -96.9102);
  });

  test('map points are reverse geocoded into a full address', () async {
    late http.Request captured;
    final service = AddressSuggestionService(
      geocodingBaseUrl: 'https://geo.example.test',
      client: MockClient((request) async {
        captured = request;
        return http.Response(
          '{"display_name":"Av. 20 de Noviembre 360, Xalapa, Mexico",'
          '"lat":"19.5273","lon":"-96.9228"}',
          200,
        );
      }),
    );

    final result = await service.reverseLocation(
      latitude: 19.5273,
      longitude: -96.9228,
    );

    expect(captured.url.path, '/reverse');
    expect(captured.url.queryParameters['zoom'], '18');
    expect(result?.displayName, contains('20 de Noviembre'));
  });
}
