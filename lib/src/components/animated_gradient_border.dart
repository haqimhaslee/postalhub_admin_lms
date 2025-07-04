import 'package:flutter/material.dart';

class AnimatedGradientBorder extends StatefulWidget {
  const AnimatedGradientBorder({
    super.key,
    this.radius = 15,
    this.thickness = 1,
    this.duration = const Duration(milliseconds: 3000),
    this.child,
    this.glowOpacity = 0.1,
    this.blurRadius = 2,
    this.spreadRadius = 1,
    this.topColor = Colors.red,
    this.bottomColor = Colors.blue,
  });

  final double radius;
  final double thickness;
  final Duration duration;
  final Widget? child;
  final double glowOpacity;
  final double blurRadius;
  final double spreadRadius;
  final Color topColor;
  final Color bottomColor;

  @override
  State<AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _animation1;
  late Animation<Alignment> _animation2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation1 = TweenSequence<Alignment>(
      <TweenSequenceItem<Alignment>>[
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
          ),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.bottomRight,
            end: Alignment.bottomLeft,
          ),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.bottomLeft,
            end: Alignment.topLeft,
          ),
          weight: 1,
        ),
      ],
    ).animate(_controller);

    _animation2 = TweenSequence<Alignment>(
      <TweenSequenceItem<Alignment>>[
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.bottomRight,
            end: Alignment.bottomLeft,
          ),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.bottomLeft,
            end: Alignment.topLeft,
          ),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
          ),
          weight: 1,
        ),
      ],
    ).animate(_controller);

    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      return Stack(children: [
        widget.child == null
            ? ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
                child: widget.child,
              )
            : const SizedBox.shrink(),
        ClipPath(
          clipper: _CenterCutPath(
            radius: widget.radius,
            thickness: widget.thickness,
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Stack(children: [
                Container(
                  width: constrains.maxWidth,
                  height: constrains.maxHeight,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(widget.radius),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.topColor,
                          spreadRadius: widget.spreadRadius,
                          blurRadius: widget.blurRadius,
                          offset: const Offset(0, 0),
                        )
                      ]),
                ),
                Align(
                  alignment: _animation2.value,
                  child: Container(
                    width: constrains.maxWidth * 0.95,
                    height: constrains.maxHeight * 0.95,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(widget.radius),
                        boxShadow: [
                          BoxShadow(
                            color: widget.bottomColor,
                            spreadRadius: widget.spreadRadius,
                            blurRadius: widget.blurRadius,
                            offset: const Offset(0, 0),
                          )
                        ]),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.radius),
                    gradient: LinearGradient(
                      begin: _animation1.value,
                      end: _animation2.value,
                      colors: <Color>[widget.topColor, widget.bottomColor],
                    ),
                  ),
                )
              ]);
            },
          ),
        )
      ]);
    });
  }
}

class _CenterCutPath extends CustomClipper<Path> {
  final double radius;
  final double thickness;
  _CenterCutPath({
    this.radius = 0,
    this.thickness = 1,
  });
  @override
  Path getClip(Size size) {
    final rect = Rect.fromLTRB(
        -size.width, -size.width, size.width * 2, size.height * 2);
    final double width = size.width - thickness * 2;
    final double height = size.height - thickness * 2;

    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(thickness, thickness, width, height),
          Radius.circular(radius - thickness)))
      ..addRect(rect);

    return path;
  }

  @override
  bool shouldReclip(covariant _CenterCutPath oldClipper) {
    return oldClipper.radius != radius || oldClipper.thickness != thickness;
  }
}
