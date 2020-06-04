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

  GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  List<int> listControl = [];

  List<Widget> widgetList = [];

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<GlobalModel>(context, listen: true).isDark;
    final setTheme = Provider.of<GlobalModel>(context, listen: false).changeTheme;
    final toggleUseSystemMode = Provider.of<GlobalModel>(context, listen: false).toggleUseSystemMode;
    final toggleAppThemeMode = Provider.of<GlobalModel>(context, listen: false).toggleAppThemeMode;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Text('设置'),
        ),
      ),
      body: Consumer<GlobalModel>(
        builder: (context, GlobalModel model, child) {
          widgetList = _buildWidgetList(model);
          return AnimatedList(
            key: listKey,
            initialItemCount: listControl.length,
            primary: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index, Animation<double> animation) {
              return SizeTransition(
                sizeFactor: animation,
                child: widgetList[listControl[index]],
              );
            },
          );
        },
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GlobalModel model = context.read<GlobalModel>();
    listControl.add(0);
    if (!model.useSystemMode) listControl.add(1);
    listControl.add(2);
  }


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // below toggle AnimateList 、 useSystemMode
    GlobalModel model = context.read<GlobalModel>();
    bool useSystemMode = model.useSystemMode;
    print('是否使用系统主题: $useSystemMode');
    if (!useSystemMode) {
      int index = listControl.indexOf(1);
      if (index < 0) {
        listControl.insert(1, 1);
        listKey.currentState?.insertItem(1, duration: Duration(milliseconds: 200));
      }
    } else {
      int index = listControl.indexOf(1);
      if (index>=0) {
        listControl.removeAt(index);
        listKey.currentState?.removeItem(index, (BuildContext context, Animation<double> animation){
          return SizeTransition(
            sizeFactor: animation,
            child: _removedItem(model),
          );
        }, duration: Duration(milliseconds: 200));
      }
    }
  }

  Widget _removedItem(GlobalModel model) {
    return _renderItem(
      title: Text('深色主题'),
      control: CupertinoSwitch(
        value: model.appThemeMode!=ThemeMode.light,
        onChanged: (isOn) {
          model.toggleAppThemeMode(isOn?ThemeMode.dark:ThemeMode.light);
        },
      ),
      model: model,
    );
  }

  List<Widget> _buildWidgetList(GlobalModel model) {
    return [
      _renderItem(
        title: Text('跟随系统主题'),
        control: CupertinoSwitch(
          value: model.useSystemMode,
          onChanged: (isOn) {
            model.toggleUseSystemMode(isOn);
          },
        ),
        model: model,
      ),
      _renderItem(
        title: Text('深色主题'),
        control: CupertinoSwitch(
          value: model.appThemeMode!=ThemeMode.light,
          onChanged: (isOn) {
            model.toggleAppThemeMode(isOn?ThemeMode.dark:ThemeMode.light);
          },
        ),
        model: model,
      ),
      Row(
        children: <Widget>[
          ...(model.isDark?darkThemeList:themeList).map((Color color) {
            return GestureDetector(
              child: Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: model.isDark?Colors.white:Colors.black),
                  color: color
                ),
              ),
              onTap: () {
                model.changeTheme((model.isDark?darkThemeList:themeList).indexOf(color));
              },
            );
          }).toList(),
        ],
      )
    ];
  }

  Widget _renderItem({ Widget title, Widget control, GlobalModel model}) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(left: width(30), right: width(30)),
      height: 50,
      decoration: BoxDecoration(
        color: model.isDark?Color(0xff666666):Color(0xfff9f9f9),
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
}