import 'package:flutter/material.dart';

class ToastBarStyle {
  final Color backgroundColor;
  final TextStyle textStyle;
  final EdgeInsets padding;
  final double borderRadius;
  final List<BoxShadow> boxShadow;
  final IconData icon;

  const ToastBarStyle({
    required this.backgroundColor,
    required this.icon,
    this.textStyle = const TextStyle(color: Colors.white, fontSize: 16),
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.borderRadius = 8.0,
    this.boxShadow = const [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10,
        offset: Offset(0, 2),
      ),
    ],
  });

  // Predefined styles
  static const info = ToastBarStyle(
    backgroundColor: Colors.blue,
    icon: Icons.info_outline,
  );

  static const success = ToastBarStyle(
    backgroundColor: Colors.green,
    icon: Icons.check_circle_outline,
  );

  static const error = ToastBarStyle(
    backgroundColor: Colors.red,
    icon: Icons.error_outline,
  );
}

class ToastBar {
  static final List<OverlayEntry> _toasts = [];

  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    ToastBarStyle style = ToastBarStyle.info,
  }) {
    final overlay = Overlay.of(context);

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: ToastAnimation(
            duration: duration,
            child: Container(
              padding: style.padding,
              decoration: BoxDecoration(
                color: style.backgroundColor,
                borderRadius: BorderRadius.circular(style.borderRadius),
                boxShadow: style.boxShadow,
              ),
              child: Row(
                children: [
                  Icon(style.icon, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message,
                      style: style.textStyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // Ensure only one toast is displayed at a time
    if (_toasts.isNotEmpty) {
      _toasts.last.remove();
    }
    _toasts.add(overlayEntry);

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
      _toasts.remove(overlayEntry);
    });
  }
}

class ToastAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const ToastAnimation({
    required this.child,
    required this.duration,
    super.key,
  });

  @override
  ToastAnimationState createState() => ToastAnimationState();
}

class ToastAnimationState extends State<ToastAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
    Future.delayed(widget.duration, _controller.reverse);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
