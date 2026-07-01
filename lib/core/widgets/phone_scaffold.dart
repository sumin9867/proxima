import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Shared scaffold for every Proxima screen.
///
/// [body] is laid out inside the device's safe area, below the real OS status
/// bar, with the home-indicator bar pinned to the bottom. Set [dark] for the
/// in-call screens so the system status-bar icons and the home indicator adopt
/// a light-on-dark style.
class PhoneScaffold extends StatelessWidget {
  const PhoneScaffold({
    super.key,
    required this.body,
    this.backgroundColor = Colors.white,
    this.dark = false,
  });

  final Widget body;
  final Color backgroundColor;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final indicatorColor = dark
        ? Colors.white.withValues(alpha: 0.22)
        : Colors.black.withValues(alpha: 0.08);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: dark
          ? SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent)
          : SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: body),
              _HomeIndicator(color: indicatorColor),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeIndicator extends StatelessWidget {
  const _HomeIndicator({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Center(
        child: Container(
          width: 134,
          height: 5,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}
