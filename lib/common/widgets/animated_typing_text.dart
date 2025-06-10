import 'package:flutter/material.dart';
import 'dart:async'; // Import for Timer

class AnimatedTypingText extends StatefulWidget {
  final String text;
  final Duration duration; // Duration for one full typing animation
  final Duration repeatInterval; // New: Interval to repeat the animation
  final TextStyle? style;
  final AlignmentGeometry? alignment;
  final double? height;
  final double? width;
  final BoxDecoration? decoration;

  const AnimatedTypingText({
    super.key,
    required this.text,
    this.duration = const Duration(milliseconds: 1500), // Total animation duration
    this.repeatInterval = const Duration(seconds: 10), // Default repeat every 10 seconds
    this.style,
    this.alignment,
    this.height,
    this.width,
    this.decoration,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedTypingTextState createState() => _AnimatedTypingTextState();
}

class _AnimatedTypingTextState extends State<AnimatedTypingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _textAnimation;
  Timer? _repeatTimer; // New: Timer for repeating the animation

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _textAnimation = IntTween(begin: 0, end: widget.text.length).animate(
      _controller,
    );

    _startAnimationAndRepeat(); // Start the animation and set up repeat
  }

  void _startAnimationAndRepeat() {
    _controller.forward(from: 0.0); // Start from the beginning

    // Set up a timer to repeat the animation
    _repeatTimer = Timer.periodic(widget.repeatInterval, (timer) {
      // Check if the controller has completed, then restart
      // We use addStatusListener for a more robust reset after completion
      if (_controller.isCompleted) {
        _controller.reset(); // Reset to the beginning
        _controller.forward(); // Start again
      } else {
        // If the animation is still running (e.g., if repeatInterval < duration)
        // you might want to handle it differently, but for full resets,
        // resetting after completion is usually desired.
        // For simple "loop every X seconds", just calling reset() and forward() works.
        _controller.reset();
        _controller.forward();
      }
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    _repeatTimer?.cancel(); // Important: Cancel the timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: widget.decoration,
      alignment: widget.alignment, // Apply alignment to the container
      child: AnimatedBuilder(
        animation: _textAnimation,
        builder: (context, child) {
          final currentLength = _textAnimation.value;
          return Text(
            widget.text.substring(0, currentLength),
            style: widget.style,
          );
        },
      ),
    );
  }
}