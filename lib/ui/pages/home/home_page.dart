import 'package:flutter/material.dart';
import 'package:flutter_place_finder/app/constants/app_constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppConstants.appTitle)),
      body: Center(),
    );
  }
}