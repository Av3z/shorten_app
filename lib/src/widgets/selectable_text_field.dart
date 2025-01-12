import 'package:flutter/material.dart';

class SelectableTextField extends StatefulWidget {
  final bool isDarkMode;
  const SelectableTextField({required this.isDarkMode, super.key});

  @override
  State<SelectableTextField> createState() => _SelectableTextFieldState();
}

class _SelectableTextFieldState extends State<SelectableTextField> {
  final TextEditingController _controller = TextEditingController();

  void _selectWordAtCursor(TextSelection selection) {
    final text = _controller.text;
    final cursorPosition = selection.baseOffset;

    int start = cursorPosition;
    int end = cursorPosition;

    // Expand selection to the start of the word
    while (start > 0 && text[start - 1] != ' ') {
      start--;
    }

    // Expand selection to the end of the word
    while (end < text.length && text[end] != ' ') {
      end++;
    }

    setState(() {
      _controller.selection = TextSelection(baseOffset: start, extentOffset: end);
    });
  }

  @override
  Widget build(BuildContext context) {
    Color swithColor = widget.isDarkMode ? Colors.white : Colors.black;
    return GestureDetector(
      onDoubleTap: () {
        _selectWordAtCursor(_controller.selection);
      },
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        expands: false,
        style: TextStyle(color: swithColor), // Adjust text color
        decoration: InputDecoration(
          hintText: 'Digite seu texto aqui...',
          hintStyle: TextStyle(color: swithColor),
          labelStyle: TextStyle(color: swithColor),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: swithColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: swithColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: swithColor),
          ),
        ),
      ),
    );
  }
}
