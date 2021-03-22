import 'package:flutter/material.dart';

class ArticleList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Text('article');
  }
}
