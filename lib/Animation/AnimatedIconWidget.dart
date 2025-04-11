import 'package:flutter/material.dart';

class AnimatedIconWidget extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;
  final Duration duration;
  final double range; // The range of movement for the animation

  const AnimatedIconWidget({
    Key? key,
    required this.icon,
    this.color = Colors.black,
    this.size = 24.0,
    this.duration = const Duration(seconds: 1),
    this.range = 20.0, // Default range
  }) : super(key: key);

  @override
  _AnimatedIconWidgetState createState() => _AnimatedIconWidgetState();
}

class _AnimatedIconWidgetState extends State<AnimatedIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double offset = _controller.value * widget.range;
        return Transform.translate(
          offset: Offset(offset, 0), // Move horizontally
          child: Icon(
            widget.icon,
            color: widget.color,
            size: widget.size,
          ),
        );
      },
    );
  }
}
