import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _haveStarted3Times = '';

  @override
  void initState() {
    super.initState();
    _incrementStartup();
  }

  Future<int> _getIntFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final startupNumber = prefs.getInt('startupNumber');

    if (startupNumber == null) {
      return 0;
    }

    return startupNumber;
  }

  Future<void> _resetCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('startupNumber', 0);
  }

  Future<void> _incrementStartup() async {
    final prefs = await SharedPreferences.getInstance();

    int lastStartupNumber = await _getIntFromSharedPreferences();
    int currentStartupNumber = ++lastStartupNumber;

    await prefs.setInt('startupNumber', currentStartupNumber);

    if (currentStartupNumber == 3) {
      setState(
          () => _haveStarted3Times = '$currentStartupNumber Times Completed');

      await _resetCounter();
    } else {
      setState(() =>
          _haveStarted3Times = '$currentStartupNumber Times Started The App');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          _haveStarted3Times,
          style: TextStyle(fontSize: 32),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _resetCounter();
        },
        elevation: 2,
        child: Icon(
          Icons.restore,
          color: ThemeData.dark().backgroundColor,
          size: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
