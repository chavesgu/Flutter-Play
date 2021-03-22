import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_play/generated/l10n.dart';
import 'package:provider/provider.dart';

import 'package:flutter_play/store/model.dart';
import 'package:flutter_play/components/GlobalComponents.dart';
import 'package:flutter_play/variable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserCenter extends StatefulWidget {
  static const String title = 'user';
  static const Icon icon = Icon(Icons.people);

  @override
  createState() => UserCenterState();
}

class UserCenterState extends State<UserCenter>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _refreshController = RefreshController();

  Widget build(BuildContext context) {
    super.build(context);
    return SmartRefresher(
      header: MaterialClassicHeader(),
      controller: _refreshController,
      onRefresh: _refresh,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Selector<GlobalModel, Locale>(
              builder: (context, locale, child) {
                return Text(S.of(context).user);
              },
              selector: (context, model) => model.lang!,
            ),
            centerTitle: true,
            pinned: true,
            toolbarHeight: 50,
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              background: MyImage(
                'assets/images/bilibili.jpg',
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Row(
                children: [
                  MyImage(
                    'https://cdn.chavesgu.com/avatar.jpg',
                    width: 50,
                    height: 50,
                    shape: BoxShape.circle,
                    preview: true,
                  ),
                  Selector<UserModel, String>(
                    selector: (context, model) => model.title,
                    builder: (context, value, child) {
                      return Text(value);
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    child: Text('切换en'),
                    onPressed: () {
                      context
                          .read<GlobalModel>()
                          .changeLocale(Locale.fromSubtags(languageCode: 'en'));
                    },
                  ),
                  ElevatedButton(
                    child: Text('切换zh'),
                    onPressed: () {
                      context.read<GlobalModel>().changeLocale(
                          Locale.fromSubtags(
                              languageCode: 'zh', scriptCode: 'Hans'));
                    },
                  ),
                ],
              ),
              ...buildList(),
            ]),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  List<Widget> buildList() {
    final List<Widget> list = [];
    for (int i = 0; i < 20; i++) {
      list.add(ListTile(
        title: Text('chaves'),
        subtitle: Text('$i'),
        trailing: Icon(IconFont.right_arrow),
      ));
    }
    return list;
  }

  void _refresh() async {
    await Future.delayed(Duration(seconds: 2));
    _refreshController.refreshCompleted();
  }
}
