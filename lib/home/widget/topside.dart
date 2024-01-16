import 'package:flutter/material.dart';

/// Top Side Titles
class TopSideTitles extends StatelessWidget {
  final List<Map<String, dynamic>> allData;
  final List<bool> selectedItems;
  final Function() onDeleteSelected;
  const TopSideTitles({
    super.key,
    required this.allData,
    required this.selectedItems,
    required this.onDeleteSelected,
  });

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
          Visibility(
            visible: selectedItems.where((selected) => selected).length > 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: MediaQuery.of(context).size.width*.6,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle delete button click here
                      onDeleteSelected();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent, // Set the background color of the button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0), // Set the rounded border
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delete selected task',
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.delete,
                          size: 24.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )

              ),
            ),
          ),
        ],
      ),
    );
  }
}