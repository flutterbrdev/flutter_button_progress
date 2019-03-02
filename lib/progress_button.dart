import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum ButtonState { error, normal, success, progress }

class ProgressButton extends StatefulWidget {
  final VoidCallback onPressed;
  final ButtonState buttonState;
  final Color splashColor;
  final Color highlightColor;
  final Color errorFillColor;
  final Widget errorChild;
  final double errorWidth;
  final double errorHeight;
  final BorderRadius borderRadius;
  final Color color;
  final Widget child;
  final double width;
  final double height;
  final Color progressFillColor;
  final Widget progressChild;
  final double progressWidth;
  final double progressHeight;
  final Color successFillColor;
  final Widget successChild;
  final double successWidth;
  final double successHeight;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final TextStyle textStyle;

  ProgressButton(
      {Key key,
      this.onPressed,
      this.buttonState,
      this.splashColor,
      this.highlightColor,
      this.errorFillColor,
      this.errorChild,
      this.errorWidth,
      this.errorHeight,
      this.color,
      this.child,
      this.width,
      this.height,
      this.progressFillColor,
      this.progressChild,
      this.progressWidth,
      this.progressHeight,
      this.successFillColor,
      this.successChild,
      this.successWidth,
      this.successHeight,
      this.borderRadius,
      this.padding,
      this.elevation = 0.0,
      this.textStyle})
      : super(key: key);

  bool get enabled => onPressed != null;

  @override
  _ProgressButtonState createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton>
    with TickerProviderStateMixin {
  AnimationController _errorAnimationController;
  AnimationController _progressAnimationController;
  AnimationController _successAnimationController;
  AnimationController _normalAnimationController;

  Animation<BorderRadius> _borderAnimation;
  Animation<double> _widthAnimation;
  Animation<Color> _colorAnimation;
  Animation<double> _scaleAnimation;

  ButtonState _oldButtonState;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _getBuilder);
  }

  @override
  void didUpdateWidget(ProgressButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    _oldButtonState = oldWidget.buttonState;

    if (oldWidget.buttonState != ButtonState.progress &&
        widget.buttonState == ButtonState.progress) {
      _progressAnimationController.stop();
      _progressAnimationController.forward();
    }

    if (oldWidget.buttonState == ButtonState.progress &&
        widget.buttonState != ButtonState.progress) {
      _progressAnimationController.stop();
      _progressAnimationController.reverse();
    }

    if (oldWidget.buttonState != ButtonState.success &&
        widget.buttonState == ButtonState.success) {
      _successAnimationController.stop();
      _successAnimationController.forward();
    }

    if (oldWidget.buttonState == ButtonState.success &&
        widget.buttonState != ButtonState.success) {
      _successAnimationController.stop();
      _successAnimationController.reverse();
    }

    if (oldWidget.buttonState != ButtonState.error &&
        widget.buttonState == ButtonState.error) {
      _errorAnimationController.stop();
      _errorAnimationController.forward();
    }

    if (oldWidget.buttonState == ButtonState.error &&
        widget.buttonState != ButtonState.error) {
      _errorAnimationController.stop();
      _errorAnimationController.reverse();
    }

    if (oldWidget.buttonState != ButtonState.normal &&
        widget.buttonState == ButtonState.normal) {
      _normalAnimationController.stop();
      _normalAnimationController.forward();
    }

    if (oldWidget.buttonState == ButtonState.normal &&
        widget.buttonState != ButtonState.normal) {
      _normalAnimationController.stop();
      _normalAnimationController.reverse();
    }
  }

  @override
  void dispose() {
    _errorAnimationController.dispose();
    _progressAnimationController.dispose();
    _successAnimationController.dispose();
    _normalAnimationController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _errorAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _progressAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _successAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _normalAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  AnimatedBuilder _getBuilder(
      BuildContext context, BoxConstraints constraints) {
    TransitionBuilder builder;
    AnimationController animationController;
    double widthBegin = 0;
    double widthEnd = 0;
    Color colorBegin;
    Color colorEnd;

    if ((widget.buttonState == ButtonState.progress)) {
      animationController = _progressAnimationController;
      widthEnd = widget.progressWidth;
      colorEnd = widget.progressFillColor;
    } else if ((widget.buttonState == ButtonState.success)) {
      animationController = _successAnimationController;
      widthEnd = widget.successWidth;
      colorEnd = widget.successFillColor;
    } else if ((widget.buttonState == ButtonState.error)) {
      animationController = _errorAnimationController;
      widthEnd = widget.errorWidth;
      colorEnd = widget.errorFillColor;
    } else {
      animationController = _normalAnimationController;
      widthEnd = widget.width;
      colorEnd = widget.color;
    }

    if (_oldButtonState == ButtonState.progress) {
      widthBegin = widget.progressWidth;
      colorBegin = widget.progressFillColor;
    } else if (_oldButtonState == ButtonState.success) {
      widthBegin = widget.successWidth;
      colorBegin = widget.successFillColor;
    } else if (_oldButtonState == ButtonState.error) {
      widthBegin = widget.errorWidth;
      colorBegin = widget.errorFillColor;
    } else {
      widthBegin = widget.width;
      colorBegin = widget.color;
    }

    _borderAnimation = BorderRadiusTween(
      begin: widget.borderRadius,
      end: BorderRadius.circular(widget.height / 2),
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.linear,
      ),
    );

    _colorAnimation = ColorTween(
      begin: colorBegin,
      end: colorEnd,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.linear,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.elasticInOut,
      ),
    );

    _widthAnimation = Tween<double>(
      begin: widthBegin,
      end: widthEnd,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.linear,
      ),
    );

    if ((widget.buttonState == ButtonState.normal)) {
      builder = (context, child) {
        return _getWidgetStateNormal();
      };
    } else if (widget.buttonState == ButtonState.progress) {
      builder = (context, child) {
        return _getWidgetStateProgress();
      };
    } else if (widget.buttonState == ButtonState.success) {
      builder = (context, child) {
        return _getWidgetStateSuccess();
      };
    } else if (widget.buttonState == ButtonState.error) {
      builder = (context, child) {
        return _getWidgetStateError();
      };
    }

    return AnimatedBuilder(
      animation: animationController,
      builder: builder,
    );
  }

  Widget _getWidgetStateError() {
    return Container(
      width: _widthAnimation.value,
      height: widget.errorHeight,
      decoration: BoxDecoration(
        color: _colorAnimation.value,
        borderRadius: _borderAnimation.value,
      ),
      child: Transform.scale(
        scale: _scaleAnimation.value,
        child: widget.errorChild,
      ),
    );
  }

  Widget _getWidgetStateNormal() {
    return Container(
      width: _widthAnimation.value,
      height: widget.height,
      child: Material(
        borderRadius: _borderAnimation.value,
        elevation: widget.elevation,
        textStyle: widget.textStyle,
        color: _colorAnimation.value,
        type: widget.color == null
            ? MaterialType.transparency
            : MaterialType.button,
        animationDuration: kThemeChangeDuration,
        child: InkWell(
          splashColor: widget.splashColor,
          highlightColor: widget.highlightColor,
          borderRadius: _borderAnimation.value,
          onTap: widget.onPressed,
          child: IconTheme.merge(
            data: IconThemeData(color: widget.textStyle?.color),
            child: Container(
              padding: widget.padding,
              child: Center(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getWidgetStateProgress() {
    return Container(
        width: _widthAnimation.value,
        height: widget.progressHeight,
        decoration: BoxDecoration(
          color: _colorAnimation.value,
          borderRadius: _borderAnimation.value,
        ),
        child: widget.progressChild);
  }

  Widget _getWidgetStateSuccess() {
    return Container(
      width: _widthAnimation.value,
      height: widget.successHeight,
      decoration: BoxDecoration(
        color: _colorAnimation.value,
        borderRadius: _borderAnimation.value,
      ),
      child: Transform.scale(
        scale: _scaleAnimation.value,
        child: widget.successChild,
      ),
    );
  }
}
