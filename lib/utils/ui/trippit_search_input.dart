import 'package:flutter/material.dart';

class TrippitSearchInput extends StatefulWidget {
  Function(String) onChanged;
  TrippitSearchInput(this.onChanged);
  @override
  State<TrippitSearchInput> createState() => _TrippitSearchInputState();
}

class _TrippitSearchInputState extends State<TrippitSearchInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: Colors.black,
            size: 20,
          ),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 5),
                  hintText: "Search users ",
                  hintStyle: TextStyle(color: Colors.black)),
              style: const TextStyle(color: Colors.black),
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
