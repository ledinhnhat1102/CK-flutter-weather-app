import 'package:flutter/material.dart';
import 'package:flutter_weather_app_v2/ui/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Weather App',
      home: HomePage(), // Sử dụng HomePage() ở đây
      debugShowCheckedModeBanner: false,
    );
  }
}
