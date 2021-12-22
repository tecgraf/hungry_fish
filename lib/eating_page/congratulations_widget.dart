import 'package:flutter/material.dart';
import 'package:hungry_fish/eating_page/eating_page.dart';
import 'package:hungry_fish/graphic_config.dart';
import 'package:hungry_fish/participant.dart';
import 'package:hungry_fish/eating_page/participant_widget.dart';

class CongratulationsWidget extends StatefulWidget {
  const CongratulationsWidget(
      {Key? key,
      required this.winner,
      required this.config,
      required this.participants})
      : super(key: key);

  final GraphicConfig config;
  final Participant winner;
  final List<Participant> participants;

  @override
  State<StatefulWidget> createState() => CongratulationsWidgetState();
}

class CongratulationsWidgetState extends State<CongratulationsWidget> {
  bool _keep = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      const SizedBox(height: 64),
      Text('Congratulations!',
          style: TextStyle(color: Colors.blue[900]!, fontSize: 40)),
      const SizedBox(height: 32),
      SizedBox(
          width: 150,
          height: 150,
          child: ParticipantWidget(
              participant: widget.winner,
              multiplier: 1,
              config: widget.config)),
      const SizedBox(height: 16),
      Text(widget.winner.name,
          style: TextStyle(color: Colors.blue[800]!, fontSize: 28)),
      const SizedBox(height: 32),
      Text('You survived!',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[700]!,
              fontSize: 32))
    ];

    if (widget.participants.length - 1 > 1) {
      children.addAll([
        const SizedBox(height: 32),
        const Text('Let\'s try again?', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 32),
        IntrinsicWidth(
            child: CheckboxListTile(
                title: Text('Keep ${widget.winner.name} in the game'),
                value: _keep,
                onChanged: (bool? value) {
                  setState(() {
                    _keep = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading)),
        const SizedBox(height: 32),
        ElevatedButton(onPressed: _onStart, child: const Text('Start'))
      ]);
    }

    return Container(
        child: SingleChildScrollView(child: Column(children: children)),
        decoration: BoxDecoration(
            border: const Border(
                left: BorderSide(width: 2), right: BorderSide(width: 2)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 10,
                blurRadius: 10,
                offset: const Offset(5, 5), // changes position of shadow
              ),
            ]));
  }

  void _onStart() {
    List<Participant> list = List.of(widget.participants);
    if (!_keep) {
      list.remove(widget.winner);
    }
    Route route = MaterialPageRoute(
        builder: (context) =>
            EatingPage(config: widget.config, participants: list));
    Navigator.pushReplacement(context, route);
  }
}
