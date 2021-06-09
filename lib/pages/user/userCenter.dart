import 'package:extended_sliver/extended_sliver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_play/store/model.dart';
import 'package:flutter_play/components/GlobalComponents.dart';
import 'package:flutter_play/variable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:animations/animations.dart';

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
    GetStorage storage = GetStorage();
    return SmartRefresher(
      header: MaterialClassicHeader(),
      controller: _refreshController,
      onRefresh: _refresh,
      child: CustomScrollView(
        slivers: [
          // ExtendedSliverAppbar(
          //   title: Text('userCenter'.tr),
          //   toolbarHeight: 50,
          //   background: MyImage(
          //     'assets/images/bilibili.jpg',
          //   ),
          // ),
          SliverAppBar(
            title: Text('userCenter'.tr),
            centerTitle: true,
            pinned: true,
            toolbarHeight: 50,
            expandedHeight: 180.0,
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
                  Obx(() => Text(Get.find<UserModel>().title.value)),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    child: Text('切换en'),
                    onPressed: () {
                      Get.updateLocale(Locale('en'));
                      storage.write('locale', {
                        'languageCode': 'en',
                        'countryCode': '',
                      });
                    },
                  ),
                  ElevatedButton(
                    child: Text('切换zh'),
                    onPressed: () {
                      Get.updateLocale(Locale('zh', 'CN'));
                      storage.write('locale', {
                        'languageCode': 'zh',
                        'countryCode': 'CN',
                      });
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
      list.add(OpenContainer(
        clipBehavior: Clip.hardEdge,
        transitionDuration: Duration(seconds: 1),
        closedBuilder: (_, action) {
          return ListTile(
            title: Text('chaves'),
            subtitle: Text('$i'),
            trailing: Icon(IconFont.right_arrow),
          );
        },
        openBuilder: (_, action) {
          return Scaffold(
            appBar: AppBar(
              title: Text('open container'),
            ),
            body: Center(
              child: Text('$i'),
            ),
          );
        },
      ));
    }
    return list;
  }

  void _refresh() async {
    await Future.delayed(Duration(seconds: 2));
    _refreshController.refreshCompleted();
  }
}
