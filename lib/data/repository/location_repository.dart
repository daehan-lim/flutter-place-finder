import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_place_finder/core/exceptions/data_exceptions.dart';
import 'package:flutter_place_finder/data/dto/naver_place_dto.dart';
import 'package:flutter_place_finder/data/dto/vworld_district_dto.dart';
import 'package:flutter_place_finder/data/model/place.dart';
import 'package:flutter_place_finder/data/network/dio_clients.dart';

abstract class LocationRepository {
  Future<List<Place>> searchPlaces(String query);

  Future<String?> getDistrictByLocation(double latitude, double longitude);
}

class LocationRepositoryImpl implements LocationRepository {
  final Dio _naverClient = buildNaverDio();
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
