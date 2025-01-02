import 'package:flutter/material.dart';
import '../components/weather_item.dart';
import '../constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart'; // Import thư viện để kiểm tra tệp

class DetailPage extends StatefulWidget {
  final String location;

  const DetailPage({Key? key, required this.location}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final Constants _constants = Constants();
  List<dynamic> forecast = [];

  final String apiKey = 'fcf854c6189244e1a0033053250101'; // API Key
  final String apiUrl = 'https://api.weatherapi.com/v1/forecast.json';

  @override
  void initState() {
    super.initState();
    fetchForecastData(widget.location);
  }

  /// Hàm kiểm tra tệp và trả về biểu tượng mặc định nếu không tìm thấy
  Future<String> getWeatherIcon(String condition) async {
    String iconPath = 'assets/${condition.toLowerCase().replaceAll(' ', '')}.png';
    try {
      await rootBundle.load(iconPath);
      return iconPath; // Nếu tìm thấy tệp, trả về đường dẫn
    } catch (e) {
      return 'assets/default.png'; // Nếu không tìm thấy tệp, trả về biểu tượng mặc định
    }
  }

  Future<void> fetchForecastData(String location) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl?key=$apiKey&q=$location&days=7'));
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
        title: Text('${widget.location} - 7-Day Forecast'),
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
              future: getWeatherIcon(condition), // Lấy biểu tượng
              builder: (context, snapshot) {
                final icon = snapshot.data ?? 'assets/default.png'; // Biểu tượng mặc định nếu lỗi

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: _constants.greyColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      // Cột hiển thị ngày và biểu tượng
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(date, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Image.asset(icon, width: 50, height: 50),
                        ],
                      ),
                      SizedBox(width: 20),
                      // Cột hiển thị nhiệt độ và trạng thái
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Max Temp: $maxTemp°C', style: TextStyle(fontSize: 16)),
                          Text('Min Temp: $minTemp°C', style: TextStyle(fontSize: 16)),
                          Text(condition, style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
