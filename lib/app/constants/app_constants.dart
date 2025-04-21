import '../../data/model/location_model.dart';

class AppConstants {
  static const appTitle = '어디든GO';
  static const randomImageUrl = 'https://picsum.photos/';

  static const sampleLocations = [
    LocationModel(
      title: '스타벅스 강남점',
      category: '카페 > 커피전문점',
      roadAddress: '서울 강남구 강남대로 396',
    ),
    LocationModel(
      title: '올리브영 명동점',
      category: '쇼핑 > 뷰티스토어',
      roadAddress: '서울 중구 명동8길 27',
    ),
    LocationModel(
      title: '파리바게뜨 잠실점',
      category: '음식점 > 베이커리',
      roadAddress: '서울 송파구 올림픽로 240',
    ),
  ];
}