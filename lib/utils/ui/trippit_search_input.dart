import 'package:flutter/material.dart';
import 'package:tripzie/utils/trppit_color.dart';

class TrippitSearchInput extends StatefulWidget {
  Function(String) onChanged;
  TrippitSearchInput(this.onChanged);
  @override
  State<TrippitSearchInput> createState() => _TrippitSearchInputState();
}

class _TrippitSearchInputState extends State<TrippitSearchInput> {
  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        border: Border.all(
          width: 0.5,
          color: edit_text_color,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: Colors.black,
            size: 17,
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 5, bottom: 8),
                  hintText: "Search users ",
                  hintStyle: TextStyle(color: Colors.black)),
              style: const TextStyle(color: Colors.black, fontSize: 12),
              onChanged: widget.onChanged,
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              border: Border.all(
                width: 0.5,
                color: Colors.transparent,
                style: BorderStyle.solid,
              ),
            ),
            child: GestureDetector(
              onTap: () {
                widget.onChanged("");
                _controller.clear();
              },
              child: const Icon(
                Icons.clear,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
