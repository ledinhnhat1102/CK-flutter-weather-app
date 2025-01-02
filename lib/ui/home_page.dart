import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart'; // Import thêm thư viện
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _cityController = TextEditingController();
  String location = 'Ha Noi';
  String weatherIcon = 'assets/default.png';
  int temperature = 0;
  String currentWeatherStatus = '';
  List hourlyWeatherForecast = [];
  String currentDate = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
  String currentTime = DateFormat('hh:mm a').format(DateTime.now());

  String apiKey = 'fcf854c6189244e1a0033053250101'; // API Key
  String apiUrl = "https://api.weatherapi.com/v1/forecast.json";

  @override
  void initState() {
    super.initState();
    fetchWeatherData(location);
  }

  Future<String> getWeatherIcon(String condition) async {
    String iconPath = 'assets/${condition.toLowerCase().replaceAll(' ', '')}.png';
    try {
      await rootBundle.load(iconPath);
      return iconPath;
    } catch (e) {
      return 'assets/default.png'; // Biểu tượng mặc định nếu không tìm thấy
    }
  }

  Future<void> fetchWeatherData(String city) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl?key=$apiKey&q=$city&days=1'));
      final data = json.decode(response.body);

      String iconPath = await getWeatherIcon(data['current']['condition']['text']);

      setState(() {
        location = data['location']['name'];
        currentWeatherStatus = data['current']['condition']['text'];
        weatherIcon = iconPath;
        temperature = data['current']['temp_c'].toInt();
        hourlyWeatherForecast = data['forecast']['forecastday'][0]['hour'];
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Hiển thị ngày giờ
            Column(
              children: [
                Text(
                  currentDate,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  currentTime,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Tên địa điểm và tìm kiếm
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(location, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text("Enter City"),
                          content: TextField(
                            controller: _cityController,
                            decoration: InputDecoration(hintText: 'Enter city name'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                fetchWeatherData(_cityController.text);
                                Navigator.pop(context);
                              },
                              child: Text("Search"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

            // Biểu tượng thời tiết và trạng thái
            Image.asset(weatherIcon, height: 100),
            Text('$temperature°C', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
            Text(currentWeatherStatus, style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),

            // Nút xem chi tiết
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(location: location),
                  ),
                );
              },
              child: Text('View Weather Details'),
            ),
            SizedBox(height: 20),

            // Dự báo thời tiết hàng giờ
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: hourlyWeatherForecast.length,
                itemBuilder: (context, index) {
                  final hourlyData = hourlyWeatherForecast[index];
                  final time = DateFormat.jm().format(DateTime.parse(hourlyData['time']));
                  return FutureBuilder<String>(
                    future: getWeatherIcon(hourlyData['condition']['text']),
                    builder: (context, snapshot) {
                      final icon = snapshot.data ?? 'assets/default.png';
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            Text(time),
                            Image.asset(icon, height: 40),
                            Text('${hourlyData['temp_c']}°C', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
