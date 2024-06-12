import 'package:flutter/material.dart';

class SelectableTextField extends StatefulWidget {

  const SelectableTextField({super.key});

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
    return GestureDetector(
      onDoubleTap: () {
        _selectWordAtCursor(_controller.selection);
      },
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        expands: false,
        decoration: const InputDecoration(
          hintText: 'Digite seu texto aqui...',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}