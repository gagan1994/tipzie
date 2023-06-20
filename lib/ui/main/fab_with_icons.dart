import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tripzie/utils/trppit_color.dart';

import '../../utils/trippit_assets.dart';

class FabWithIcons extends StatefulWidget {
  final List<IconData> icons;
  ValueChanged<int> onIconTapped;
  FabWithIcons({required this.icons, required this.onIconTapped});
  @override
  State createState() => FabWithIconsState();
}

class FabWithIconsState extends State<FabWithIcons>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.icons.length, (int index) {
          return _buildChild(index);
        }).toList()
          ..insert(0, _buildFab()),
      ),
    );
  }

  Widget _buildChild(int index) {
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = accent_color;
    return Container(
      height: 70.0,
      width: 56.0,
      alignment: FractionalOffset.topCenter,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _controller,
          curve: Interval(0.0, 1.0 - index / widget.icons.length / 2.0,
              curve: Curves.easeOut),
        ),
        child: FloatingActionButton(
          backgroundColor: backgroundColor,
          mini: true,
          child: Icon(widget.icons[index], color: foregroundColor),
          onPressed: () => _onTapped(index),
        ),
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton.small(
      backgroundColor: Colors.white,
      onPressed: () async {
        print("hamburger menu pressed ${_controller.isDismissed}");
        if (_controller.isDismissed) {
          await _controller.forward();
        } else {
          await _controller.reverse();
        }
        setState(() {});
      },
      tooltip: 'Increment',
      child: !_controller.isDismissed
          ? const Icon(
              Icons.clear,
              color: accent_color,
            )
          : SvgPicture.asset(
              ic_hamburger_menu,
              height: 15,
              width: 15,
            ),
    );
  }

  void _onTapped(int index) {
    _controller.reverse();
    widget.onIconTapped(index);
  }
}
