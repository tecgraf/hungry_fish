class GraphicConfig {
  GraphicConfig({this.drawPlaceholderOnly = false, this.debugEnabled = false});

  final bool drawPlaceholderOnly;
  final bool debugEnabled;

  final double participantsAreaMargin = .1;
  final double participantSize = .12;

  final double farWaveHeight = .18;
  final double nearWaveHeight = .2;

  final double fishWidth = .16;
  final double fishHeight = .26;
}
