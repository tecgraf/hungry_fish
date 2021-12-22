import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hungry_fish/config_page/config_page.dart';
import 'package:hungry_fish/fish_widget.dart';
import 'package:hungry_fish/graphic_config.dart';
import 'package:hungry_fish/loader_page/loader_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  GraphicConfig _config = GraphicConfig();

  final TextEditingController _urlFieldController = TextEditingController(
      text: 'https://tecgraf.github.io/hungry_fish_demo/data');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Positioned(right: 100, top: -180, child: _fish()),
      Positioned(left: 100, top: -180, child: _fish2()),
      Positioned.fill(
          child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: _column(),
          ),
        ],
      ))
    ]));
  }

  Widget _column() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _logo(),
      _message(),
      _urlField(),
      _loadButton(),
      Expanded(child: Container()),
      _footer()
    ]);
  }

  Widget _fish() {
    return Opacity(
        child: ConstrainedBox(
            child: FishWidget(config: _config, multiplier: 1, jumping: true),
            constraints:
                const BoxConstraints.tightFor(width: 150, height: 300)),
        opacity: .3);
  }

  Widget _fish2() {
    return Transform.rotate(
      angle: _degreesToRadian(-30),
      child: _fish(),
    );
  }

  double _degreesToRadian(double degrees) {
    return degrees * math.pi / 180;
  }

  Widget _footer() {
    return Padding(
        child: Row(children: [
          _configButton(),
          Expanded(child: Container()),
          Image.asset('images/tecgraf_logo.png', height: 40),
          const SizedBox(width: 16),
          const FlutterLogo(size: 40)
        ]),
        padding: const EdgeInsets.all(16));
  }

  Widget _configButton() {
    return IconButton(icon: const Icon(Icons.settings), onPressed: _onConfig);
  }

  void _onConfig() async {
    GraphicConfig config = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConfigPage(config: _config)),
    );
    setState(() {
      _config = config;
    });
  }

  Widget _urlField() {
    return FractionallySizedBox(
        child: TextField(
            controller: _urlFieldController,
            decoration: InputDecoration(
                labelText: "Data URL",
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3, color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3, color: Colors.blue),
                  borderRadius: BorderRadius.circular(15),
                ),
                suffixIcon: IconButton(
                  onPressed: _urlFieldController.clear,
                  icon: const Icon(Icons.clear),
                ))),
        widthFactor: .4);
  }

  Widget _logo() {
    return Padding(
        padding: const EdgeInsets.only(top: 100, bottom: 30),
        child: Align(
            child: Text('Hungry Fish',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900]!,
                    fontSize: 70)),
            alignment: Alignment.center));
  }

  Widget _message() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: Align(
            child: Text('The last one who survives will win the prize!',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800]!,
                    fontSize: 24)),
            alignment: Alignment.center));
  }

  Widget _loadButton() {
    return Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Align(
            child: ElevatedButton(
                onPressed: () => _onLoad(context), child: const Text('Load')),
            alignment: Alignment.center));
  }

  void _onLoad(BuildContext context) {
    Route route = MaterialPageRoute(
        builder: (context) =>
            LoaderPage(config: _config, url: _urlFieldController.text));
    Navigator.pushReplacement(context, route);
  }
}
