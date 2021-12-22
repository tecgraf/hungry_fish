import 'package:flutter/material.dart';
import 'package:hungry_fish/graphic_config.dart';
import 'package:hungry_fish/participant.dart';

class ParticipantWidget extends StatelessWidget {
  const ParticipantWidget(
      {Key? key,
      required this.participant,
      required this.multiplier,
      required this.config})
      : super(key: key);

  final Participant participant;
  final double multiplier;
  final GraphicConfig config;

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (config.drawPlaceholderOnly) {
      widget = Container(color: participant.color);
    } else {
      widget = CircleAvatar(
          backgroundColor: participant.color,
          child: FractionallySizedBox(
              widthFactor: .9 - (.1 * multiplier),
              heightFactor: .9 - (.1 * multiplier),
              child: CircleAvatar(
                  backgroundImage: MemoryImage(participant.image))));
    }
    return widget;
  }
}
