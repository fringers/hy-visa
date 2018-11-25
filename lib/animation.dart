import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:hy_visa/main.dart';
import 'dart:io';

class AnimatedLogo extends AnimatedWidget {
  static final _sizeTween = Tween<double>(begin: 0.0, end: 220.0);

  AnimatedLogo({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Container(
        color: Colors.lightBlueAccent,
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            height: _sizeTween.evaluate(animation),
            width: _sizeTween.evaluate(animation),
            child: CustomLogo(),
          ),
        ));
  }
}

class CustomLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Image.asset(
          "assets/img/confirmed.png",
        ),
      ),
    );
  }
}

class CustomAnimation extends StatefulWidget {
  _CustomAnimationState createState() => _CustomAnimationState();
}

class _CustomAnimationState extends State<CustomAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1400), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        sleep(new Duration(seconds: 2));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HyVisaApp()),
        );
      } else if (status == AnimationStatus.dismissed) {
        controller.stop();
      }
    });

    controller.forward();
  }

  Widget build(BuildContext context) {
    return AnimatedLogo(animation: animation);
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}

void main() {
  runApp(CustomAnimation());
}
