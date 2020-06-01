import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_play/variable.dart';
import 'package:flutter_play/store/global.dart';

class SettingPage extends StatefulWidget {
  static const name = '/setting';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SettingPageState();
  }
}

class SettingPageState extends State<SettingPage> {

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<GlobalModel>(context, listen: true).isDark;
    final setTheme = Provider.of<GlobalModel>(context, listen: false).changeTheme;
    final toggleUseSystemMode = Provider.of<GlobalModel>(context, listen: false).toggleUseSystemMode;
    final toggleAppThemeMode = Provider.of<GlobalModel>(context, listen: false).toggleAppThemeMode;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('设置'),
      ),
      body: Consumer<GlobalModel>(
        builder: (context, GlobalModel model, child) {
          return ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              _renderItem(
                title: Text('跟随系统主题'),
                control: CupertinoSwitch(
                  value: model.useSystemMode,
                  onChanged: (isOn) {
                    toggleUseSystemMode(isOn);
                  },
                ),
                isDark: model.isDark,
              ),
              Offstage(
                offstage: model.useSystemMode,
                child: AnimatedOpacity(
                  opacity: model.useSystemMode?0:1,
                  duration: Duration(milliseconds: 200),
                  child: _renderItem(
                    title: Text('深色主题'),
                    control: CupertinoSwitch(
                      value: model.appThemeMode!=ThemeMode.light,
                      onChanged: (isOn) {
                        toggleAppThemeMode(isOn?ThemeMode.dark:ThemeMode.light);
                      },
                    ),
                    isDark: model.isDark,
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  ...(isDark?darkThemeList:themeList).map((Color color) {
                    return GestureDetector(
                      child: Container(
                        width: 40,
                        height: 40,
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: isDark?Colors.white:Colors.black),
                          color: color
                        ),
                      ),
                      onTap: () {
                        setTheme((isDark?darkThemeList:themeList).indexOf(color));
                      },
                    );
                  }).toList(),
                ],
              )
            ],
          );
        },
      ),
    );
  }


  Widget _renderItem({ Widget title, Widget control, bool isDark = false}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: width(30), right: width(30)),
      height: 50,
      decoration: BoxDecoration(
        color: isDark?Color(0xff666666):Color(0xfff9f9f9),
        border: Border(
          top: BorderSide(color: Color(0xffcccccc), width: .5),
          bottom: BorderSide(color: Color(0xffcccccc), width: .5),
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          title,
          control,
        ],
      ),
    );
  }

  List<Widget> _renderList(handler) {
    final List<Widget> list = [];
    for(var i=0;i<themeList.length;i++) {
      list.add(GestureDetector(
        onTap: () {
          handler(i);
        },
        child: Container(
          width: 30,
          height: 30,
          margin: EdgeInsets.all(20),
          color: themeList[i],
        ),
      ));
    }
    return list;
  }
}