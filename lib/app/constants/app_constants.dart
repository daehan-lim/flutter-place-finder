import '../../data/model/place.dart';

class AppConstants {
  static const appTitle = '어디든GO';
  static const naverApiBaseUrl = 'https://openapi.naver.com/v1/search';
  static const vworldApiBaseUrl = 'https://api.vworld.kr/req';
  static const currentLocationKeyword = '[내 위치]';
  static const envErrorMessage = '.env 파일에 VWORLD_API_KEY, NAVER_CLIENT_ID, NAVER_CLIENT_SECRET 값을 모두 설정해주세요.';

  static const samplePlaces = [
    Place(
      title: '스타벅스 강남점',
      category: '카페 > 커피전문점',
      address: '서울 강남구 강남대로 396', link: '',
    ),
    Place(
      title: '올리브영 명동점',
      category: '쇼핑 > 뷰티스토어',
      address: '서울 중구 명동8길 27', link: '',
    ),
    Place(
      title: '파리바게뜨 잠실점',
      category: '음식점 > 베이커리',
      address: '서울 송파구 올림픽로 240', link: '',
    ),
  ];
}