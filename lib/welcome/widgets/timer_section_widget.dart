import 'dart:async';

import 'package:flutter/material.dart';

class TimerDisplay extends StatefulWidget {
  const TimerDisplay({super.key, required this.sleepTime});

  final DateTime? sleepTime;

  @override
  State<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<TimerDisplay> {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.sleepTime != null) {
        startTimer();
        setState(() => _isInitialized = true);
      }
    });
  }

  void startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final diff = widget.sleepTime!.difference(now);
      if (diff.isNegative || diff.inSeconds <= 0) {
        setState(() {
          _remaining = Duration.zero;
        });
        timer.cancel();
        return;
      }

      setState(() {
        _remaining = diff;
      });
    });
  }

  @override
  void didUpdateWidget(TimerDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sleepTime != oldWidget.sleepTime) {
      if (widget.sleepTime != null) {
        startTimer();
        setState(() => _isInitialized = true);
      } else {
        _timer?.cancel();
        setState(() {
          _remaining = Duration.zero;
          _isInitialized = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Text('Loading...', style: TextStyle(color: Colors.white));
    }

    return Text(
      _formatDuration(_remaining),
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        fontFamily: "Poppins",
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours H : $minutes M : $seconds S";
  }
}
