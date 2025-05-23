import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_place_finder/ui/pages/web/place_web_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/place.dart';

class PlaceWebPage extends ConsumerWidget {
  final Place place;

  const PlaceWebPage(this.place, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(place.link);

    final viewModel = ref.read(placeWebPageViewModelProvider.notifier);
    final isLoading = ref.watch(placeWebPageViewModelProvider);

    final link = place.link;

    return Scaffold(
      appBar: AppBar(title: Text(place.title)),
      body: Stack(
        children: [
          InAppWebView(
            initialSettings: InAppWebViewSettings(
              mediaPlaybackRequiresUserGesture: true,
              javaScriptEnabled: true,
              userAgent:
                  'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1',
            ),
            initialUrlRequest: URLRequest(url: WebUri(link)),
            onLoadStop: (controllerInstance, url) {
              viewModel.setLoading(false);
            },
          ),
          if (isLoading)
            const Center(child: CupertinoActivityIndicator(radius: 20)),
        ],
      ),
    );
  }
}
