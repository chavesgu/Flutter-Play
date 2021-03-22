import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart' show InnerDrawerState;
import 'package:flutter_play/pages/home/search.dart';

import 'package:flutter_play/variable.dart';
import 'package:flutter_play/components/GlobalComponents.dart';

class HomePage extends StatefulWidget {
  HomePage({this.drawerKey});

  final GlobalKey<InnerDrawerState>? drawerKey;

  @override
  createState() => HomePageState();
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  bool _hideInputClear = true;
  FocusNode? _focusNode;
  final _inputController = MyTextEditingController();
  String get query => _inputController.text;
  set query(String value) {
    assert(query != null);
    _inputController.text = value;
  }

  final _scrollController = ScrollController();
  bool _hideGoTop = true;
  double _goTopOpacity = 0;

  // data
  List<dynamic> bannerList = [];
  List<dynamic> recommendMusicList = [];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        toolbarHeight: 50,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _focusNode?.unfocus();
                if (widget.drawerKey != null)
                  widget.drawerKey!.currentState?.open();
              },
            );
          },
        ),
        title: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(36)),
          child: Container(
            height: 36,
            child: TextField(
              keyboardType: TextInputType.text,
              style: TextStyle(
                  fontSize: width(30),
                  textBaseline: TextBaseline.alphabetic,
                  color: Colors.black),
              focusNode: _focusNode,
              controller: _inputController,
              cursorColor: Theme.of(context).primaryColor,
              textInputAction: TextInputAction.search,
              onSubmitted: _submit,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                hintText: '请输入关键词搜索',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: width(30),
                ),
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  size: width(48),
                ),
                suffixIcon: Offstage(
                  offstage: _hideInputClear,
                  child: GestureDetector(
                    onTap: _clearInput,
                    child: Icon(
                      Icons.close,
                      size: width(48),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView(),
    );
  }

  @override
  void initState() {
    _focusNode = FocusNode(debugLabel: "search");
    _inputController.addListener(_inputChange);
    _scrollController.addListener(_scrollListen);
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _inputController.removeListener(_inputChange);
    _scrollController.removeListener(_scrollListen);
    super.dispose();
  }

  void _submit(value) {
    Navigator.of(context).pushNamed(
      '${SearchPage.name}?text=${Uri.encodeQueryComponent(value)}',
    );
  }

  void _inputChange() {
    if (query.length > 0) {
      if (_hideInputClear) {
        setState(() {
          _hideInputClear = false;
        });
      }
    } else {
      if (!_hideInputClear) {
        setState(() {
          _hideInputClear = true;
        });
      }
    }
  }

  void _clearInput() {
    setState(() {
      query = '';
      _hideInputClear = true;
    });
  }

  void _scrollListen() {
    if (_scrollController.offset > 200) {
      if (_hideGoTop) {
        setState(() {
          _hideGoTop = false;
          _goTopOpacity = 1;
        });
      }
    } else {
      if (!_hideGoTop) {
        setState(() {
          _goTopOpacity = 0;
          _hideGoTop = true;
        });
      }
    }
  }

  void _goTop() {
    _scrollController.animateTo(0,
        duration: Duration(milliseconds: 600), curve: Curves.linear);
  }
}
