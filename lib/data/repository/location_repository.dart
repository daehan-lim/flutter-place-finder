import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_place_finder/core/exceptions/data_exceptions.dart';
import 'package:flutter_place_finder/data/dto/naver_place_dto.dart';
import 'package:flutter_place_finder/data/dto/vworld_district_dto.dart';
import 'package:flutter_place_finder/data/model/place.dart';
import 'package:flutter_place_finder/data/network/dio_clients.dart';

/// Repository interface for location-related operations.
abstract class LocationRepository {
  /// Searches for places based on the provided query string.
  ///
  /// [query] The search term to find places.
  /// Returns a list of [Place] objects matching the query.
  Future<List<Place>> searchPlaces(String query);

  /// Gets the district name for a geographical location.
  ///
  /// [latitude] The latitude coordinate.
  /// [longitude] The longitude coordinate.
  /// Returns the district name as a string, or null if not found.
  Future<String?> getDistrictByLocation(double latitude, double longitude);
}

/// Implementation of the LocationRepository using Naver and Vworld APIs.
class LocationRepositoryImpl implements LocationRepository {
  /// Dio client for Naver API requests
  final Dio _naverClient = buildNaverDio();

  /// Dio client for Vworld API requests
  final Dio _vworldClient = buildVworldDio();

  @override
  Future<List<Place>> searchPlaces(String query) async {
    try {
      final response = await _naverClient.get(
        '/local.json',
        queryParameters: {'query': query, 'display': 5},
      );
      if (response.statusCode == 200) {
        return List<Place>.from(
          NaverPlaceDto.fromJson(
            response.data,
          ).items.map((ItemDto itemDto) => itemDto.toModel()),
        );
      }
      throw ApiException(statusCode: response.statusCode, data: response.data);
    } on DioException catch (e) {
      throw NetworkException(e.toString());
    }
  }

  Future<String?> getDistrictByLocation(
    double longitude,
    double latitude,
  ) async {
    final vworldApiKey = dotenv.env['VWORLD_API_KEY'];
    if (vworldApiKey == null) {
      throw EnvFileException('VWORLD_API_KEY가 .env 파일에 설정되지 않았습니다.');
    }
    try {
      final response = await _vworldClient.get(
        '/data',
        queryParameters: {
          'request': 'GetFeature',
          'key': vworldApiKey,
          'data': 'LT_C_ADEMD_INFO',
          'geomFilter': 'POINT($longitude $latitude)',
          'geometry': false,
          'size': 100,
        },
      );
      if (response.statusCode == 200 &&
          response.data['response']['status'] == 'OK') {
        return VworldDistrictDto.fromJson(response.data)
            .response
            ?.result
            ?.featureCollection
            ?.features
            .first
            .properties
            ?.fullNm;
      }
      throw ApiException(statusCode: response.statusCode, data: response.data);
    } on DioException catch (e) {
      throw NetworkException(e.toString());
    }
  }
}
