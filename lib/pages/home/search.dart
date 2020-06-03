import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchPage extends StatefulWidget {
  static const name = '/search';

  SearchPage(this.text);

  final String text;

  @override
  createState()=> SearchPageState();
}

class SearchPageState extends State<SearchPage> {

  get searchText => widget.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          centerTitle: true,
          title: Text(
            '搜索结果',
          ),
          brightness: Brightness.light,
          backgroundColor: Colors.white,
        ),
      ),
      body: Center(
        child: Text(
          '搜索词: $searchText',
        ),
      ),
    );
  }
}