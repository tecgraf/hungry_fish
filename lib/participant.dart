import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Represents a participant in the game.
class Participant {
  Participant(
      {required this.id,
      required this.name,
      required this.image,
      required this.color});

  final int id;
  final String name;
  final Uint8List image;
  final Color color;
  Offset locationFactor = Offset.infinite;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Participant &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  void setLocation(
      {required double participantSize,
      required List<Participant> list,
      required screenSize}) {
    double size = participantSize * screenSize.height * 1.5;
    Random random = Random();
    Offset ref = Offset(random.nextDouble(), random.nextDouble());
    for (int i = 0; i < 10; i++) {
      bool collision = false;
      for (Participant participant in list) {
        Offset center = Offset(participant.locationFactor.dx * screenSize.width,
            participant.locationFactor.dy * screenSize.height);
        Rect r = Rect.fromCenter(center: center, width: size, height: size);

        Offset center2 =
            Offset(ref.dx * screenSize.width, ref.dy * screenSize.height);
        Rect r2 = Rect.fromCenter(center: center2, width: size, height: size);

        if (r.overlaps(r2)) {
          collision = true;
          break;
        }
      }
      if (collision == false) {
        locationFactor = ref;
        return;
      }
      ref = Offset(random.nextDouble(), random.nextDouble());
    }
    locationFactor = ref;
  }

  @override
  String toString() {
    return 'Participant{id: $id, name: $name}';
  }
}
