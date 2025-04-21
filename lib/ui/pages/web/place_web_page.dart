import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../data/model/place.dart';


class PlaceWebPage extends StatelessWidget {
  final Place place;

  const PlaceWebPage(this.place, {super.key});

  @override
  Widget build(BuildContext context) {
    print(place.link);
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: InAppWebView(
        initialSettings: InAppWebViewSettings(
          mediaPlaybackRequiresUserGesture: true,
          javaScriptEnabled: true,
          userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1',
        ),
        initialUrlRequest: URLRequest(
          url: WebUri(place.link),
        ),
      ),
    );
  }
}
