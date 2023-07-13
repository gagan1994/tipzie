import 'package:flutter/material.dart';
import 'package:tripzie/utils/trppit_color.dart';

class TrippitTabDetails {
  String tabTitle;
  Widget body;
  Widget? bottomButton;
  TrippitTabDetails(this.tabTitle, this.body, {this.bottomButton});
}

class TrippitTabView extends StatefulWidget {
  Function(int) selectedTab;
  List<TrippitTabDetails> tabdetails;
  TrippitTabView(this.selectedTab, this.tabdetails);
  @override
  _TrippitTabViewState createState() => _TrippitTabViewState();
}

class _TrippitTabViewState extends State<TrippitTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController =
        TabController(length: widget.tabdetails.length, vsync: this);
    _tabController.addListener(() {
      setState(() {});
      widget.selectedTab(_tabController.index);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // give the tab bar a height [can change hheight to preferred height]
          Container(
            height: 45,
            width: 300,
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(
                25.0,
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: accent_color,
                boxShadow: [
                  BoxShadow(
                    color: accent_color.withOpacity(0.3),
                    blurRadius: 25,
                    offset: const Offset(0, 20), // changes position of shadow
                  ),
                ],
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              tabs: _getTabsTitle(),
            ),
          ),
          // tab bar view here
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _getTabBody(),
            ),
          ),
        ],
      ),
    );
  }

  _getTabsTitle() {
    List<Tab> tabs = [];
    for (int i = 0; i < widget.tabdetails.length; i++) {
      tabs.add(Tab(
        text: widget.tabdetails[i].tabTitle,
      ));
    }
    return tabs;
  }

  List<Widget> _getTabBody() {
    List<Widget> tabs = [];
    for (int i = 0; i < widget.tabdetails.length; i++) {
      tabs.add(widget.tabdetails[i].body);
    }
    return tabs;
  }
}
