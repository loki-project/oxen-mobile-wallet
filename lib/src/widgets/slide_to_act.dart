import 'dart:math';

import 'package:flutter/material.dart';

class SlideToAct extends StatefulWidget {
  const SlideToAct({
    Key? key,
    this.sliderButtonIconSize = 24,
    this.sliderButtonIconPadding = 16,
    this.sliderButtonYOffset = 0,
    this.height = 70,
    required this.outerColor,
    this.borderRadius = 52,
    this.elevation = 6,
    this.animationDuration = const Duration(milliseconds: 300),
    this.reversed = false,
    this.alignment = Alignment.center,
    this.submittedIcon,
    this.onFutureSubmit,
    this.onSubmit,
    this.child,
    this.innerColor,
    required this.text,
    this.sliderButtonIcon,
  }) : super(key: key);

  /// The size of the sliding icon
  final double sliderButtonIconSize;

  /// Tha padding of the sliding icon
  final double sliderButtonIconPadding;

  /// The offset on the y axis of the slider icon
  final double sliderButtonYOffset;

  /// The child that is rendered instead of the default Text widget
  final Widget? child;

  /// The height of the component
  final double height;

  /// The color of the inner circular button, of the tick icon of the text.
  /// If not set, this attribute defaults to primaryIconTheme.
  final Color? innerColor;

  /// The color of the external area and of the arrow icon.
  /// If not set, this attribute defaults to accentColor from your theme.
  final Color? outerColor;

  /// The text showed in the default Text widget
  final String text;

  /// The borderRadius of the sliding icon and of the background
  final double borderRadius;

  /// Callback called on submit
  final Future Function()? onFutureSubmit;
  final VoidCallback? onSubmit;

  /// Elevation of the component
  final double elevation;

  /// The widget to render instead of the default icon
  final Widget? sliderButtonIcon;

  /// The widget to render instead of the default submitted icon
  final Widget? submittedIcon;

  /// The duration of the animations
  final Duration animationDuration;

  /// If true the widget will be reversed
  final bool reversed;

  /// the alignment of the widget once it's submitted
  final Alignment alignment;

  @override
  SlideToActState createState() => SlideToActState();
}

/// Use a GlobalKey to access the state. This is the only way to call [SlideToActState.reset]
class SlideToActState extends State<SlideToAct> with TickerProviderStateMixin {
  final GlobalKey _containerKey = GlobalKey();
  final GlobalKey _sliderKey = GlobalKey();
  double _dx = 0;
  double _maxDx = 0;

  double get _progress => _dx == 0 ? 0 : _dx / _maxDx;
  double _endDx = 0;
  double? _containerWidth;
  bool submitted = false;
  late AnimationController
      _cancelAnimationController;

  @override
  Widget build(BuildContext context) {
    if (widget.onSubmit != null && widget.onFutureSubmit != null) {
      throw Exception('onSubmit and onFutureSubmit can\'t be used both');
    }

    return Align(
      alignment: widget.alignment,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(widget.reversed ? pi : 0),
        child: Container(
          key: _containerKey,
          height: widget.height,
          width: _containerWidth,
          constraints: _containerWidth != null
              ? null
              : BoxConstraints.expand(height: widget.height),
          child: Material(
            elevation: widget.elevation,
            color: widget.outerColor ?? Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: submitted
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(widget.reversed ? pi : 0),
                    child: Center(
                      child: Stack(
                        clipBehavior: Clip.antiAlias,
                        children: <Widget>[
                          widget.submittedIcon ??
                              Icon(
                                Icons.done,
                                color: widget.innerColor ??
                                    Theme.of(context).primaryIconTheme.color,
                              ),
                          Positioned.fill(
                            right: 0,
                            child: Container(
                                color: widget.outerColor ??
                                    Theme.of(context).accentColor,
                              ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Opacity(
                        opacity: 1 - 1 * _progress,
                        child: Transform(
                          alignment: Alignment.center,
                          transform:
                              Matrix4.rotationY(widget.reversed ? pi : 0),
                          child: widget.child ??
                              Text(
                                widget.text,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: widget.innerColor ??
                                      Theme.of(context).primaryIconTheme.color,
                                  fontSize: 24,
                                ),
                              ),
                        ),
                      ),
                      Positioned(
                        left: widget.sliderButtonYOffset,
                        child: Transform.translate(
                          offset: Offset(_dx, 0),
                          child: Container(
                            key: _sliderKey,
                            child: GestureDetector(
                              onHorizontalDragUpdate: onHorizontalDragUpdate,
                              onHorizontalDragEnd: (details) async {
                                _endDx = _dx;
                                if (_progress <= 0.8) {
                                  await _cancelAnimation();
                                } else {
                                  if (widget.onFutureSubmit != null) {
                                    await widget.onFutureSubmit!.call();
                                  } else if (widget.onSubmit != null) {
                                    widget.onSubmit!.call();
                                  }
                                  await _cancelAnimation();
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(
                                      widget.borderRadius),
                                  color: widget.innerColor ??
                                      Theme.of(context)
                                          .primaryIconTheme
                                          .color,
                                  child: Container(
                                    padding: EdgeInsets.all(
                                        widget.sliderButtonIconPadding),
                                    child: Transform.rotate(
                                      angle: -pi * _progress,
                                      child: Center(
                                        child: widget.sliderButtonIcon ??
                                            Icon(
                                              Icons.arrow_forward,
                                              size:
                                                  widget.sliderButtonIconSize,
                                              color: widget.outerColor ??
                                                  Theme.of(context)
                                                      .accentColor,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dx = (_dx + details.delta.dx).clamp(0.0, _maxDx);
    });
  }

  /// Call this method to revert the animations
  Future reset() async {
    submitted = false;
    await _cancelAnimation();
  }

  Future _cancelAnimation() async {
    _cancelAnimationController.reset();
    final animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _cancelAnimationController,
      curve: Curves.fastOutSlowIn,
    ));

    animation.addListener(() {
      if (mounted) {
        setState(() {
          _dx = (_endDx - (_endDx * animation.value));
        });
      }
    });
    await _cancelAnimationController.forward().orCancel;
  }

  @override
  void initState() {
    super.initState();

    _cancelAnimationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final containerBox = _containerKey.currentContext!.findRenderObject() as RenderBox;
      _containerWidth = containerBox.size.width;

      final sliderBox = _sliderKey.currentContext!.findRenderObject() as RenderBox;
      final sliderWidth = sliderBox.size.width;

      _maxDx =
          _containerWidth! - (sliderWidth / 2) - 40 - widget.sliderButtonYOffset;
    });
  }

  @override
  void dispose() {
    _cancelAnimationController.dispose();
    super.dispose();
  }
}
