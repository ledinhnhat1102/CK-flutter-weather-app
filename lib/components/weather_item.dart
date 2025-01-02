import 'package:flutter/material.dart';

class WeatherItem extends StatelessWidget {
  final String date;
  final int maxTemp;
  final int minTemp;
  final String condition;
  final String iconPath;

  const WeatherItem({
    Key? key,
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
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
              Image.asset(iconPath, width: 50, height: 50),
            ],
          ),
          SizedBox(width: 20),
          // Cột hiển thị nhiệt độ và trạng thái
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nhiệt độ cao nhất: $maxTemp°C', style: TextStyle(fontSize: 16)),
              Text('Nhiệt độ thấp nhất: $minTemp°C', style: TextStyle(fontSize: 16)),
              Text(condition, style: TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}
