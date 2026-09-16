import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nando/core/constants/app_data.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  Duration _elapsed = Duration.zero;
  Duration _lastLap = Duration.zero;
  bool _isRunning = false;
  Timer? _timer;
  final List<Duration> _laps = [];

  void _startTimer() {
    if (_isRunning) return;

    _timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      setState(() {
        _elapsed += const Duration(milliseconds: 10);
      });
    });

    setState(() {
      _isRunning = true;
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _pauseTimer();
    setState(() {
      _elapsed = Duration.zero;
      _lastLap = Duration.zero;
      _laps.clear();
    });
  }

  void _recordLap() {
    if (_elapsed == _lastLap) return;

    setState(() {
      _laps.insert(0, _elapsed - _lastLap);
      _lastLap = _elapsed;
    });
  }

  String _formatTime(Duration duration) {
    final totalMilliseconds = duration.inMilliseconds;

    if (totalMilliseconds < 60 * 60 * 1000) {
      final minutes = (totalMilliseconds ~/ 60000) % 60;
      final seconds = (totalMilliseconds ~/ 1000) % 60;
      final centiseconds = (totalMilliseconds % 1000) ~/ 10;
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')},${centiseconds.toString().padLeft(2, '0')}';
    }

    final hours = totalMilliseconds ~/ (60 * 60 * 1000);
    final minutes = (totalMilliseconds ~/ 60000) % 60;
    final seconds = (totalMilliseconds ~/ 1000) % 60;
    final centiseconds = (totalMilliseconds % 1000) ~/ 10;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')},${centiseconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch'),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatTime(_elapsed),
                      style: const TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _resetTimer,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: kPrimaryColor),
                              foregroundColor: kPrimaryColor,
                            ),
                            child: const Text('Reset'),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _isRunning ? _pauseTimer : _startTimer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kAccentColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(_isRunning ? 'Pause' : 'Start'),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _recordLap,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: kAccentColor),
                              foregroundColor: kAccentColor,
                            ),
                            child: const Text('Lap'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lap terbaru',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kTextMuted),
                    ),
                    const SizedBox(height: 12),
                    if (_laps.isEmpty)
                      const Text(
                        'Belum ada lap tercatat.',
                        style: TextStyle(fontSize: 14, color: kTextMuted),
                      )
                    else
                      ..._laps.asMap().entries.map((entry) {
                        final index = entry.key + 1;
                        final lapDuration = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Lap $index', style: const TextStyle(fontWeight: FontWeight.w600)),
                              Text(_formatTime(lapDuration), style: const TextStyle(color: kPrimaryColor)),
                            ],
                          ),
                        );
                      }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

