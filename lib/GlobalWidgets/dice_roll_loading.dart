import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DiceRollLoadingIndicator extends StatefulWidget {
  final String message;
  final double size;
  final Color ringColor;
  final Color textColor;

  const DiceRollLoadingIndicator({
    super.key,
    this.message = 'Loading...',
    this.size = 150,
    this.ringColor = const Color(0xFFB35A22),
    this.textColor = Colors.white,
  });

  @override
  State<DiceRollLoadingIndicator> createState() =>
      _DiceRollLoadingIndicatorState();
}

class _DiceRollLoadingIndicatorState extends State<DiceRollLoadingIndicator> {
  late final VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video/diceroll.mp4');
    _initializeController();
  }

  Future<void> _initializeController() async {
    await _controller.setLooping(true);
    await _controller.setVolume(0);
    await _controller.initialize();
    await _controller.play();

    if (!mounted) return;
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final circleSize = widget.size;

    return SizedBox(
      width: circleSize + 48,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: circleSize + 24,
            height: circleSize + 24,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.ringColor,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x332F1407),
                  blurRadius: 22,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF2D7BF),
              ),
              child: ClipOval(
                child: _isInitialized
                    ? FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _controller.value.size.width,
                          height: _controller.value.size.height,
                          child: VideoPlayer(_controller),
                        ),
                      )
                    : Center(
                        child: SizedBox(
                          width: 34,
                          height: 34,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: widget.textColor,
                          ),
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: widget.textColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.none,
              decorationColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}

class DiceRollLoadingScreen extends StatelessWidget {
  final String message;

  const DiceRollLoadingScreen({super.key, this.message = 'Loading...'});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4D2612), Color(0xFF8A4720), Color(0xFFB86029)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: SizedBox.expand(
        child: Center(child: DiceRollLoadingIndicator(message: message)),
      ),
    );
  }
}

class PageIntroLoader extends StatefulWidget {
  final Widget child;
  final String message;
  final Duration minimumDuration;

  const PageIntroLoader({
    super.key,
    required this.child,
    this.message = 'Loading...',
    this.minimumDuration = const Duration(milliseconds: 3000),
  });

  @override
  State<PageIntroLoader> createState() => _PageIntroLoaderState();
}

class _PageIntroLoaderState extends State<PageIntroLoader> {
  Timer? _timer;
  bool _showIntro = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.minimumDuration, () {
      if (!mounted) return;
      setState(() {
        _showIntro = false;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: TickerMode(
            enabled: !_showIntro,
            child: Offstage(offstage: _showIntro, child: widget.child),
          ),
        ),
        if (_showIntro)
          Positioned.fill(
            child: DiceRollLoadingScreen(message: widget.message),
          ),
      ],
    );
  }
}
