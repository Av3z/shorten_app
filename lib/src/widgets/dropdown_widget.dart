import 'package:flutter/material.dart';

Widget dropdownWidget(value, options, callback, isDarkMode) {
  return DropdownButton<String>(
    underline: Container(
      height: 2,
      color: Colors.grey[700],
    ),
    dropdownColor: isDarkMode ? Colors.grey[900] : Colors.grey[200],
    padding: const EdgeInsets.only(left: 8, right: 8),
    value: value,
    onChanged: callback,
    items: options.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
      );
    }).toList(),
  );
}
