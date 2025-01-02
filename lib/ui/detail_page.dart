import 'package:flutter/material.dart';
import '../constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart'; // kt neu tep rong
import '../components/weather_item.dart';

class DetailPage extends StatefulWidget {
  final String location;

  const DetailPage({Key? key, required this.location}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final Constants _constants = Constants();
  List<dynamic> forecast = [];

  final String apiKey = 'fcf854c6189244e1a0033053250101';
  final String apiUrl = 'https://api.weatherapi.com/v1/forecast.json';

  @override
  void initState() {
    super.initState();
    fetchForecastData(widget.location);
  }

  /// check icon, neu ko co icon thi ve mac dinh
  Future<String> getWeatherIcon(String condition) async {
    String iconPath = 'assets/${condition.toLowerCase().replaceAll(' ', '')}.png';
    try {
      await rootBundle.load(iconPath);
      return iconPath; // tim thay  duong dan
    } catch (e) {
      return 'assets/default.png'; // tra ve icon mac dinh
    }
  }

  Future<void> fetchForecastData(String location) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl?key=$apiKey&q=$location&days=7'));
      //vi du https://api.weatherapi.com/v1/forecast.json?key=fcf854c6189244e1a0033053250101&q=Hanoi&days=7
      final data = json.decode(response.body);

      setState(() {
        forecast = data['forecast']['forecastday'];
      });
    } catch (e) {
      print('Error fetching forecast data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.location} - 7 ngày tới'),
        backgroundColor: _constants.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: forecast.length,
          itemBuilder: (context, index) {
            final day = forecast[index];
            final date = day['date'];
            final maxTemp = day['day']['maxtemp_c'].toInt();
            final minTemp = day['day']['mintemp_c'].toInt();
            final condition = day['day']['condition']['text'];

            return FutureBuilder<String>(
              future: getWeatherIcon(condition), // icon
              builder: (context, snapshot) {
                final icon = snapshot.data ?? 'assets/default.png'; // ko co lay icoon mac dinh

                // Sdung Weather de  hien thi du lieu
                return WeatherItem(
                  date: date,
                  maxTemp: maxTemp,
                  minTemp: minTemp,
                  condition: condition,
                  iconPath: icon,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
