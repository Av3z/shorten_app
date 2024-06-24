import 'package:flutter/material.dart';

Widget dropdownWidget(value, options, callback) {
  return DropdownButton<String>(
                value: value,
                onChanged: callback,
                items: options.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              );
}