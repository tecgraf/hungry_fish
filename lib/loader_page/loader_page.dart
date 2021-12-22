import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:hungry_fish/graphic_config.dart';
import 'package:hungry_fish/participant.dart';
import 'package:http/http.dart' as http;
import 'package:hungry_fish/eating_page/eating_page.dart';

class LoaderPage extends StatefulWidget {
  const LoaderPage({Key? key, required this.url, required this.config})
      : super(key: key);

  final String url;

  final GraphicConfig config;

  @override
  State<StatefulWidget> createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> {
  double _value = 0;

  @override
  void initState() {
    super.initState();
    loadParticipants().then(_onLoadFinish);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SizedBox(
                child: CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                    color: Colors.blue,
                    value: _value,
                    strokeWidth: 15),
                width: 100,
                height: 100)));
  }

  Future<List<Participant>> loadParticipants() async {
    List<Participant> list = [];

    String json = await http.read(Uri.parse('${widget.url}/data.json'),
        headers: {"Cache-Control": "no-cache"});

    List<dynamic> participantsArray = jsonDecode(json);

    List<Color> colors = _colors();
    int id = 1;
    for (Map<String, dynamic> map in participantsArray) {
      if (id == 4) {
        // break;
      }
      String name = map['name'];
      String asset = map['asset'];

      Response response = await http.get(Uri.parse('${widget.url}/$asset'),
          headers: {"Cache-Control": "no-cache"});
      Uint8List image = response.bodyBytes;

      list.add(Participant(
          id: id++, name: name, image: image, color: colors.removeAt(0)));
      if (colors.isEmpty) {
        colors = _colors();
      }
      setState(() {
        _value = id / participantsArray.length;
      });
    }

    return list;
  }

  List<Color> _colors() {
    List<Color> list = [];
    list.add(Colors.blue);
    list.add(Colors.orange);
    list.add(Colors.pink);
    list.add(Colors.red);
    list.add(Colors.green);
    list.add(Colors.black);
    list.add(Colors.brown);
    list.add(Colors.deepPurple);
    list.add(Colors.indigo);
    list.add(Colors.teal);
    list.shuffle();
    return list;
  }

  void _onLoadFinish(List<Participant> participants) {
    Route route = MaterialPageRoute(
        builder: (context) =>
            EatingPage(config: widget.config, participants: participants));
    Navigator.pushReplacement(context, route);
  }
}
