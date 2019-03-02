import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_button_progress/progress_button.dart';
import 'package:rxdart/rxdart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Button',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Button States'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final _controllerButtonState = BehaviorSubject<ButtonState>();
  Stream<ButtonState> _buttonState;
  var index = 0;

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
            StreamBuilder<ButtonState>(
                stream: _buttonState,
                initialData: ButtonState.normal,
                builder: (context, snapshot) {
                  return GestureDetector(
                    onTap: () {
                      switch (index + 1) {
                        case 1:
                          _controllerButtonState.sink.add(ButtonState.progress);
                          break;
                        case 2:
                          _controllerButtonState.sink.add(ButtonState.success);
                          break;
                        case 3:
                          _controllerButtonState.sink.add(ButtonState.error);
                          break;
                        default:
                          _controllerButtonState.sink.add(ButtonState.normal);
                          break;
                      }
                    },
                    child: ProgressButton(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.blue,
                      width: 250,
                      height: 50,
                      progressWidth: 50,
                      progressHeight: 50,
                      progressFillColor: Colors.blue,
                      progressChild: Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      successFillColor: Colors.green,
                      successHeight: 50,
                      successWidth: 50,
                      successChild: Center(
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 42,
                        ),
                      ),
                      errorFillColor: Colors.red,
                      errorHeight: 50,
                      errorWidth: 50,
                      errorChild: Center(
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 42,
                        ),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                      buttonState: snapshot.data,
                    ),
                  );
                }),
          ],
        ),
      ),
      bottomNavigationBar: StreamBuilder<ButtonState>(
          stream: _buttonState,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case ButtonState.normal:
                index = 0;
                break;
              case ButtonState.progress:
                index = 1;
                break;
              case ButtonState.success:
                index = 2;
                break;
              case ButtonState.error:
                index = 3;
                break;
              default:
            }

            return BottomNavigationBar(
              currentIndex: index,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text("Normal"),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.launch),
                  title: Text("Progress"),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check),
                  title: Text("Success"),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.error),
                  title: Text("Error"),
                ),
              ],
              type: BottomNavigationBarType.fixed,
              onTap: _tapBottom,
            );
          }),
    );
  }

  @override
  void dispose() {
    _controllerButtonState.close();
    super.dispose();
  }

  @override
  void initState() {
    _buttonState = _controllerButtonState.stream;
    super.initState();
  }

  void _tapBottom(int value) {
    switch (value) {
      case 0:
        _controllerButtonState.sink.add(ButtonState.normal);
        break;
      case 1:
        _controllerButtonState.sink.add(ButtonState.progress);
        break;
      case 2:
        _controllerButtonState.sink.add(ButtonState.success);
        break;
      case 3:
        _controllerButtonState.sink.add(ButtonState.error);
        break;
    }
  }
}
