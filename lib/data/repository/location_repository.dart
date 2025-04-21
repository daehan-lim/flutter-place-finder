import 'package:dio/dio.dart';
import 'package:flutter_place_finder/core/exceptions/data_exceptions.dart';
import 'package:flutter_place_finder/data/dto/naver_place_dto.dart';
import 'package:flutter_place_finder/data/model/place.dart';
import 'package:flutter_place_finder/data/network/dio_clients.dart';

abstract class LocationRepository {
  Future<List<Place>> searchPlaces(String query);
}

class LocationRepositoryImpl implements LocationRepository{
  final Dio _naverClient = buildBaseDio();

  @override
  Future<List<Place>> searchPlaces(String query) async {
    try {
      final response = await _naverClient.get('/search');
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
}
