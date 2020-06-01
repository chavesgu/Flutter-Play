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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '搜索结果',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          '搜索词: $searchText',
        ),
      ),
    );
  }
}