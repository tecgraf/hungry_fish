import 'package:flutter/material.dart';
import 'package:hungry_fish/graphic_config.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key, required this.config}) : super(key: key);

  final GraphicConfig config;

  @override
  State<StatefulWidget> createState() => ConfigPageState();
}

class ConfigPageState extends State<ConfigPage> {
  bool _drawPlaceholderOnly = false;
  bool _debugEnabled = false;

  @override
  void initState() {
    super.initState();
    _drawPlaceholderOnly = widget.config.drawPlaceholderOnly;
    _debugEnabled = widget.config.debugEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: IntrinsicWidth(
                child: Column(children: [
      CheckboxListTile(
          title: const Text('Draw placeholder only'),
          value: _drawPlaceholderOnly,
          onChanged: (bool? value) {
            setState(() {
              _drawPlaceholderOnly = value!;
            });
          },
          controlAffinity: ListTileControlAffinity.leading),
      CheckboxListTile(
          title: const Text('Debug enabled'),
          value: _debugEnabled,
          onChanged: (bool? value) {
            setState(() {
              _debugEnabled = value!;
            });
          },
          controlAffinity: ListTileControlAffinity.leading),
      const SizedBox(height: 32),
      ElevatedButton(child: const Text('Close'), onPressed: _onClose)
    ], mainAxisAlignment: MainAxisAlignment.center))));
  }

  void _onClose() {
    Navigator.pop(
        context,
        GraphicConfig(
            drawPlaceholderOnly: _drawPlaceholderOnly,
            debugEnabled: _debugEnabled));
  }
}
