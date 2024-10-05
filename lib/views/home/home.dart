import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final clipboardContentStream = StreamController<String>.broadcast();
  var _box;

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((directory) {
      Hive.init(directory.path);
      Hive.openBox('clipboard').then(
        (value) {
          _box = Hive.box('clipboard');
          _getText();
        },
      );
    });
  }

  Stream get clipboardText => clipboardContentStream.stream;
  Future<VoidCallback?> _getText() async {
    List<dynamic> clipboardList = _box?.get('clipboard') ?? [];

    setState(() {
      _box?.get('clipboard');
    });

    Timer.periodic(
      const Duration(seconds: 2),
      (timer) {
        Clipboard.getData('text/plain').then(
          (clipboardContent) {
            String? clipboardText = clipboardContent?.text;
            String? hasText = clipboardList.firstWhereOrNull((text) => text == clipboardText);
            if (hasText == null && clipboardText != null) {
              clipboardList.insert(0, clipboardText);
              setState(
                () {
                  _box.put('clipboard', clipboardList);
                },
              );
            }
          },
        );
      },
    );

    return null;
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> data = _box?.get('clipboard') ?? ["Nenhum clip"];
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: data.map((text) {
            if (text != null) {
              return SelectableText(text);
            } else {
              return Container();
            }
          }).toList(),
        ),
      ),
    );
  }
}
