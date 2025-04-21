import 'package:flutter_place_finder/data/model/place.dart';

class NaverPlaceDto {
  NaverPlaceDto({
    required this.lastBuildDate,
    required this.total,
    required this.start,
    required this.display,
    required this.items,
  });

  final String lastBuildDate;
  final int total;
  final int start;
  final int display;
  final List<ItemDto> items;

  factory NaverPlaceDto.fromJson(Map<String, dynamic> json) {
    return NaverPlaceDto(
      lastBuildDate: json["lastBuildDate"] ?? "",
      total: json["total"] ?? 0,
      start: json["start"] ?? 0,
      display: json["display"] ?? 0,
      items:
          json["items"] == null
              ? []
              : List<ItemDto>.from(json["items"]!.map((x) => ItemDto.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "lastBuildDate": lastBuildDate,
    "total": total,
    "start": start,
    "display": display,
    "items": items.map((x) => x.toJson()).toList(),
  };
}

class ItemDto {
  ItemDto({
    required this.title,
    required this.link,
    required this.category,
    required this.description,
    required this.telephone,
    required this.address,
    required this.roadAddress,
    required this.mapx,
    required this.mapy,
  });

  final String title;
  final String link;
  final String category;
  final String description;
  final String telephone;
  final String address;
  final String roadAddress;
  final String mapx;
  final String mapy;

  factory ItemDto.fromJson(Map<String, dynamic> json) {
    return ItemDto(
      title: json["title"] ?? "",
      link: json["link"] ?? "",
      category: json["category"] ?? "",
      description: json["description"] ?? "",
      telephone: json["telephone"] ?? "",
      address: json["address"] ?? "",
      roadAddress: json["roadAddress"] ?? "",
      mapx: json["mapx"] ?? "",
      mapy: json["mapy"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "link": link,
    "category": category,
    "description": description,
    "telephone": telephone,
    "address": address,
    "roadAddress": roadAddress,
    "mapx": mapx,
    "mapy": mapy,
  };

  Place toModel() => Place(
    title: title,
    category: category,
    address: roadAddress,
    link: link,
  );
}
