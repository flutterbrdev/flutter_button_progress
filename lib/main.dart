import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final StreamController<double> _controller = StreamController<double>();
  AnimationController _animationController;
  Stream<double> _width;

  Color _init = Colors.blue;
  Color _finish = Colors.green;

  ColorTween _color;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _color = ColorTween(begin: Colors.blue, end: Colors.green);
    _width = _controller.stream;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<double>(
                stream: _width,
                initialData: 250,
                builder: (context, snapshot) {
                  if (snapshot.data == 50) {
                    _animationController.forward();
                  }

                  return AnimatedContainer(
                    height: 50,
                    width: snapshot.data,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOutQuad,
                    decoration: BoxDecoration(
                      color:
                          snapshot.data == 50 ? Colors.green[500] : Colors.blue,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {
                          _controller.sink.add(50);
                        },
                        child: snapshot.data == 50
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(12.0),
                                child: Text('Flat Button'),
                              ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
