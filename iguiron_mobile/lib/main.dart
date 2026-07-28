import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeModel(),
      child: const MyApp(),
    ),
  );
}

// app state for global theme
class ThemeModel with ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  // toggle theme state and then notify other widgets that waits for the theme
  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Counter App',
      theme: themeModel.isDark ? ThemeData.dark() : ThemeData.light(),
      home: const CounterPage(),
    );
  }
}

// default page
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

// state class where counter is saved locally
class _CounterPageState extends State<CounterPage> {
  int _counter = 0; 

  // updates counter state
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ephemeral State Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// second screen for theme toggle
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('App State Example'),
        actions: [
          // switch toggle for the dark mode theme
          Switch(
            value: themeModel.isDark,
            onChanged: (_) => themeModel.toggleTheme(),
          ),
        ],
      ),
      body: const Center(
        child: Text('Toggle the theme using the switch in the app bar.'),
      ),
    );
  }
}