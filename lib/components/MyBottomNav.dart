import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyBottomNav extends StatelessWidget {
  MyBottomNav({
    Key key,
    this.height = 50.0,
    @required this.items,
    this.currentIndex = 0,
    this.onTap,
    this.iconSize,
    this.color = CupertinoColors.inactiveGray,
    this.activeColor,
    this.backgroundColor = const Color(0xfff9f9f9),
    this.border = const Border(
      top: BorderSide(
        width: 0.4,
        color: Color(0x33000000),
        style: BorderStyle.solid,
      )
    )
  }) :assert(items != null),
      assert(
        items.length >= 2,
        "Tabs need at least 2 items to conform to Apple's HIG",
      ),
      assert(currentIndex != null),
      assert(0 <= currentIndex && currentIndex < items.length),
      super(key: key);

  final double height;

  final List<MyBottomNavItem> items;

  final int currentIndex;

  final ValueChanged<int> onTap;

  final Color activeColor;

  final Color color;

  final Color backgroundColor;

  final Border border;

  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      height: height+bottomPadding,
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        border: border,
        color: backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildTabs(context, items),
      ),
    );
  }

  List<Widget> _buildTabs(BuildContext context, List<MyBottomNavItem> items) {
    final List<Widget> result = <Widget>[];
    for (int index = 0; index < items.length; index++) {
      final bool isActive = index == currentIndex;
      MyBottomNavItem item = items[index];
      result.add(Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap == null ? null : () { onTap(index); },
          child: Center(
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    isActive?
                    item.activeIcon==null?IconTheme(
                      data: IconThemeData(color: activeColor??Theme.of(context).primaryColor, size: iconSize),
                      child: item.icon,
                    ):item.activeIcon:
                    IconTheme(
                      data: IconThemeData(color: color, size: iconSize),
                      child: item.icon,
                    ),
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 12,
                        color: isActive?activeColor??Theme.of(context).primaryColor:color,
                      ),
                    ),
                  ],
                ),
                item.badge!=null?Positioned(
                  top: 2,
                  right: -5,
                  child: item.badge>0?Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        item.badge.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ):Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                ):SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ));
    }
    return result;
  }
}

class MyBottomNavItem {
  MyBottomNavItem({
    @required this.icon,
    this.activeIcon,
    this.title,
    this.badge,
  }) : assert(icon != null);

  final Icon icon;

  final Icon activeIcon;

  final String title;

  final int badge;
}