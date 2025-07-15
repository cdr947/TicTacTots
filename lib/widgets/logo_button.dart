import 'package:flutter/material.dart';

class LogoButton extends StatefulWidget {
  final String asset;
  final VoidCallback onTap;
  const LogoButton({required this.asset, required this.onTap, super.key});

  @override
  State<LogoButton> createState() => _LogoButtonState();
}

class _LogoButtonState extends State<LogoButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  bool _tapped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 8.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    if (_tapped) return;
    setState(() => _tapped = true);
    await _controller.forward();
    widget.onTap();
    _controller.reset();
    setState(() => _tapped = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnim.value, child: child);
        },
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              widget.asset,
              fit: BoxFit.contain,
              errorBuilder:
                  (context, error, stackTrace) =>
                      Icon(Icons.image, color: Colors.grey[400]),
            ),
          ),
        ),
      ),
    );
  }
}
