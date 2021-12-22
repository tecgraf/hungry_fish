import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hungry_fish/eating_page/congratulations_widget.dart';
import 'package:hungry_fish/fish_widget.dart';
import 'package:hungry_fish/participant.dart';
import 'package:hungry_fish/eating_page/participant_widget.dart';
import 'package:hungry_fish/graphic_config.dart';
import 'package:hungry_fish/eating_page/wave_widget.dart';
import 'package:hungry_fish/eating_page/debug_area_widget.dart';

class EatingPage extends StatefulWidget {
  const EatingPage({Key? key, required this.config, required this.participants})
      : super(key: key);

  final List<Participant> participants;
  final GraphicConfig config;

  @override
  State<StatefulWidget> createState() => _ScenarioState();
}

class _ScenarioState extends State<EatingPage> with TickerProviderStateMixin {
  final List<Participant> _participants = [];

  late AnimationController _participantsController;
  late AnimationController _farWaveController;
  late AnimationController _nearWaveController;
  late AnimationController _fishController;

  double _participantsMultiplier = 0;
  double _currentFarWaveMultiplier = 0;
  double _currentNearWaveMultiplier = 0;
  double _fishMultiplier = 0;

  Participant? _nextVictim;
  Participant? _survivor;

  bool _isFishJumping = false;
  bool _needSetLocation = true;

  @override
  void initState() {
    super.initState();
    _participantsController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..addListener(() {
            setState(() {
              _participantsMultiplier = _participantsController.value;
            });
          });
    _participantsController.repeat(reverse: true);

    _farWaveController = AnimationController(
        duration: const Duration(seconds: 30),
        vsync: this,
        lowerBound: 0,
        upperBound: 360)
      ..addListener(() {
        setState(() {
          _currentFarWaveMultiplier = _farWaveController.value;
        });
      });
    _farWaveController.repeat();

    _nearWaveController = AnimationController(
        duration: const Duration(seconds: 5),
        vsync: this,
        lowerBound: 0,
        upperBound: 360)
      ..addListener(() {
        setState(() {
          _currentNearWaveMultiplier = _nearWaveController.value;
        });
      });
    _nearWaveController.repeat();

    _fishController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    CurvedAnimation _fishAnimation =
        CurvedAnimation(parent: _fishController, curve: Curves.easeInOutQuart);
    _fishAnimation.addListener(() {
      setState(() {
        _fishMultiplier = _fishAnimation.value;
      });
    });
    _fishController.addStatusListener(_onFishAnimationEnd);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_needSetLocation) {
      _needSetLocation = false;
      for (Participant participant in widget.participants) {
        participant.locationFactor = Offset.infinite;
      }
      _setParticipantsLocation().then((value) => _scheduleNextHunt());
    }
  }

  @override
  void dispose() {
    _participantsController.dispose();
    _farWaveController.dispose();
    _nearWaveController.dispose();
    _fishController.removeStatusListener(_onFishAnimationEnd);
    _fishController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: _layoutBuilder));
  }

  Widget _layoutBuilder(BuildContext context, BoxConstraints constraints) {
    List<Widget> children = [];

    final double farWaveHeight =
        constraints.maxHeight * widget.config.farWaveHeight;
    children.add(Positioned(
        left: 0,
        right: 0,
        top: constraints.maxHeight - farWaveHeight,
        bottom: 0,
        child: WaveWidget(
            near: false,
            phase: _currentFarWaveMultiplier,
            config: widget.config)));

    final double participantSize =
        constraints.maxHeight * widget.config.participantSize;

    double participantsAreaMargin =
        constraints.maxHeight * widget.config.participantsAreaMargin;
    Size participantsAreaSize = Size(
        math.max(0, constraints.maxWidth - participantsAreaMargin),
        math.max(
            0, constraints.maxHeight - farWaveHeight - participantsAreaMargin));

    Rect participantsArea = Rect.fromLTWH(
        (constraints.maxWidth - participantsAreaSize.width) / 2,
        (constraints.maxHeight - farWaveHeight - participantsAreaSize.height) /
            2,
        participantsAreaSize.width,
        participantsAreaSize.height);

    Offset participantsAreaCenter = participantsArea.center;

    Rect participantsLocationArea = Rect.fromLTWH(
        math.min(participantsAreaCenter.dx,
            participantsArea.left + (participantSize / 2)),
        math.min(participantsAreaCenter.dy,
            participantsArea.top + (participantSize / 2)),
        math.max(participantsAreaCenter.dx,
            participantsArea.width - participantSize),
        math.max(participantsAreaCenter.dy,
            participantsArea.height - participantSize));

    if (widget.config.debugEnabled) {
      children.add(Positioned.fromRect(
          rect: participantsArea,
          child: const DebugAreaWidget(color: Colors.black)));
      children.add(Positioned.fromRect(
          rect: participantsLocationArea,
          child: const DebugAreaWidget(color: Colors.black)));
    }

    double fishY =
        constraints.maxHeight - (constraints.maxHeight * _fishMultiplier);
    for (Participant participant in _participants) {
      double x = participantsLocationArea.left +
          (participantsLocationArea.width * participant.locationFactor.dx) -
          (participantSize / 2);
      double y = participantsLocationArea.top +
          (participantsLocationArea.height * participant.locationFactor.dy) -
          (participantSize / 2);

      if (!(participant.id == _nextVictim?.id && fishY < y)) {
        children.add(Positioned.fromRect(
            key: ValueKey(participant.id),
            rect: Rect.fromLTWH(x, y, participantSize, participantSize),
            child: ParticipantWidget(
                participant: participant,
                multiplier: _participantsMultiplier,
                config: widget.config)));
      }
    }

    if (_nextVictim != null) {
      final double fishHeight =
          constraints.maxHeight * widget.config.fishHeight;
      final double fishWidth = constraints.maxHeight * widget.config.fishWidth;
      double fishX = participantsLocationArea.left +
          (participantsLocationArea.width * _nextVictim!.locationFactor.dx) -
          (fishWidth / 2);
      children.add(Positioned.fromRect(
          rect: Rect.fromLTWH(fishX, fishY, fishWidth, fishHeight),
          child: FishWidget(
              config: widget.config,
              multiplier: _fishMultiplier,
              jumping: _isFishJumping)));
    } else if (_survivor != null) {
      final double width = constraints.maxWidth * .6;
      final double x = (constraints.maxWidth - width) / 2;
      children.add(Positioned.fromRect(
          rect: Rect.fromLTWH(x, 0, width, constraints.maxHeight),
          child: CongratulationsWidget(
              winner: _survivor!,
              config: widget.config,
              participants: widget.participants)));
    }

    final double nearWaveHeight =
        constraints.maxHeight * widget.config.nearWaveHeight;
    children.add(Positioned(
        left: 0,
        right: 0,
        top: constraints.maxHeight - nearWaveHeight,
        bottom: 0,
        child: WaveWidget(
            near: true,
            phase: _currentNearWaveMultiplier,
            config: widget.config)));

    return Stack(children: children);
  }

  void _scheduleNextHunt() {
    Future.delayed(const Duration(seconds: 1), () {
      _nextVictim = _participants[math.Random().nextInt(_participants.length)];
      _isFishJumping = true;
      _fishController.reset();
      _fishController.forward();
    });
  }

  void _onFishAnimationEnd(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _isFishJumping = false;
        _participants.remove(_nextVictim);
      });
      _fishController.reverse();
    } else if (status == AnimationStatus.dismissed) {
      if (_participants.length == 1) {
        setState(() {
          _nextVictim = null;
          _survivor = _participants.first;
        });
      } else {
        _scheduleNextHunt();
      }
    }
  }

  Future<void> _setParticipantsLocation() async {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    for (Participant participant in widget.participants) {
      participant.setLocation(
          participantSize: widget.config.participantSize,
          list: _participants,
          screenSize: mediaQueryData.size);
      await Future.delayed(const Duration(milliseconds: 250), () {
        setState(() {
          _participants.add(participant);
        });
      });
    }
  }
}
