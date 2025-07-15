import 'package:flutter/material.dart';
import 'dart:math';

class ConfettiWidget extends StatefulWidget {
  final bool show;
  final VoidCallback? onEnd;
  const ConfettiWidget({super.key, required this.show, this.onEnd});

  @override
  State<ConfettiWidget> createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_ConfettiPiece> _pieces;
  final int _numPieces = 40;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _pieces = List.generate(_numPieces, (i) => _ConfettiPiece());
    if (widget.show) _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.onEnd != null) {
        widget.onEnd!();
      }
    });
  }

  @override
  void didUpdateWidget(covariant ConfettiWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !_controller.isAnimating) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show) return SizedBox.shrink();
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _ConfettiPainter(_controller.value, _pieces),
          );
        },
      ),
    );
  }
}

class _ConfettiPiece {
  final double x;
  final double y;
  final double angle;
  final double speed;
  final Color color;
  final double size;
  _ConfettiPiece()
    : x = Random().nextDouble(),
      y = Random().nextDouble() * 0.2,
      angle = Random().nextDouble() * 2 * pi,
      speed = 0.5 + Random().nextDouble() * 0.5,
      color = Colors.primaries[Random().nextInt(Colors.primaries.length)],
      size = 8 + Random().nextDouble() * 8;
}

class _ConfettiPainter extends CustomPainter {
  final double progress;
  final List<_ConfettiPiece> pieces;
  _ConfettiPainter(this.progress, this.pieces);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in pieces) {
      final dx = p.x * size.width + sin(p.angle) * 20 * progress;
      final dy = p.y * size.height + progress * size.height * p.speed;
      final paint = Paint()..color = p.color;
      canvas.drawCircle(Offset(dx, dy), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
