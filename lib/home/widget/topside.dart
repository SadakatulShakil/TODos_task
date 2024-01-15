import 'package:flutter/material.dart';

/// Top Side Titles
class TopSideTitles extends StatelessWidget {
  const TopSideTitles({
    super.key,
    required this.allData,
  });

  final List<Map<String, dynamic>> allData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 15, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hello, Friend!",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 23,
              color: Colors.grey.shade500,
            ),
          ),
          Text(
            "Your New \nTasks ${allData.isNotEmpty ? "(${allData.length})" : " "}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 55,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}