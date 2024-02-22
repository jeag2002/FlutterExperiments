//https://www.kodeco.com/24499516-getting-started-with-flutter#toc-anchor-019
//https://stackoverflow.com/questions/69755091/set-min-max-screen-size-in-flutter-windows
//https://www.randomnumberapi.com/api/v1.0/random?min=1&max=100&count=1
//https://medium.com/@raphaelrat_62823/consuming-rest-api-in-flutter-a-guide-for-developers-2460d90320aa

import 'dart:async';
//import 'dart:math' as math;
import 'dart:convert';

import 'dart:io';
import 'package:window_manager/window_manager.dart';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  if (Platform.isWindows) {
    WindowManager.instance.setMinimumSize(const Size(480, 600));
    WindowManager.instance.setMaximumSize(const Size(480, 600));
  }
  runApp(const GraphFlutterApp());
}

class GraphFlutterApp extends StatelessWidget {
  const GraphFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    var themeData = ThemeData(
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        surface: Colors.green,
        onSurface: Colors.black,
        // Colors that are not relevant to AppBar in DARK mode:
        primary: Colors.lightGreen,
        onPrimary: Colors.lightGreen,
        secondary: Colors.lightGreen,
        onSecondary: Colors.lightGreen,
        background: Colors.lightGreen,
        onBackground: Colors.lightGreen,
        error: Colors.lightGreen,
        onError: Colors.lightGreen,
      ),
    );
    return MaterialApp(
      title: 'Graph Application',
      theme: themeData,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Graph Application'),
        ),
        body: const Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: LineChartSample10(),
            ),
          ],
        ),
      ),
    );
  }
}

class LineChartSample10 extends StatefulWidget {
  const LineChartSample10({super.key});

  final Color sinColor = const Color.fromARGB(255, 0, 0, 255);
  final Color cosColor = const Color.fromARGB(255, 0, 255, 255);

  @override
  State<LineChartSample10> createState() => _LineChartSample10State();
}

class RandomNumberApi {
  Future<List<int>?> getRandomNumbers() async {
    var client = http.Client();
    var uri = Uri.parse(
        'https://www.randomnumberapi.com/api/v1.0/random?min=1&max=100&count=2');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var body = response.body;
      return List<int>.from(json.decode(body));
    }
    return null;
  }
}

class RandomNumberService {
  final _api = RandomNumberApi();
  Future<List<int>?> getRandomNumbers() async {
    return _api.getRandomNumbers();
  }
}

class _LineChartSample10State extends State<LineChartSample10> {
  final limitCount = 100;
  final sinPoints = <FlSpot>[];
  final cosPoints = <FlSpot>[];

  double xValue = 0;
  double step = 0.05;

  late Timer timer;

  final randomNumberService = RandomNumberService();

  void setPoints() async {
    final List<int>? values = await randomNumberService.getRandomNumbers();
    sinPoints.add(FlSpot(xValue, values![0].toDouble()));
    cosPoints.add(FlSpot(xValue, values[1].toDouble()));
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      while (sinPoints.length > limitCount) {
        sinPoints.removeAt(0);
        cosPoints.removeAt(0);
      }
      setState(() {
        setPoints();
      });
      xValue += step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return cosPoints.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Text(
                'x: ${xValue.toStringAsFixed(1)}',
                style: const TextStyle(
                  color: Color.fromARGB(255, 255, 0, 0),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'sin: ${sinPoints.last.y.toStringAsFixed(1)}',
                style: TextStyle(
                  color: widget.sinColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'cos: ${cosPoints.last.y.toStringAsFixed(1)}',
                style: TextStyle(
                  color: widget.cosColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              AspectRatio(
                aspectRatio: 1.5,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: 100,
                      minX: sinPoints.first.x,
                      maxX: sinPoints.last.x,
                      lineTouchData: const LineTouchData(enabled: false),
                      clipData: const FlClipData.all(),
                      gridData: const FlGridData(
                        show: true,
                        drawVerticalLine: false,
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        sinLine(sinPoints),
                        cosLine(cosPoints),
                      ],
                      titlesData: const FlTitlesData(
                        show: false,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        : Container();
  }

  LineChartBarData sinLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: const FlDotData(
        show: false,
      ),
      gradient: LinearGradient(
        colors: [widget.sinColor.withOpacity(0), widget.sinColor],
        stops: const [0.1, 1.0],
      ),
      barWidth: 4,
      isCurved: false,
    );
  }

  LineChartBarData cosLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: const FlDotData(
        show: false,
      ),
      gradient: LinearGradient(
        colors: [widget.cosColor.withOpacity(0), widget.cosColor],
        stops: const [0.1, 1.0],
      ),
      barWidth: 4,
      isCurved: false,
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}


/*
// Main Function
void main() {
// Giving command to runApp() to run the app.
  runApp(const MyApp());
}

// Widget is used to create UI in flutter framework.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title of the application
      title: 'Hello World Demo Application',
      // theme of the widget
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // Inner UI of the application
      home: const MyHomePage(title: 'Home page'),
    );
  }
}

/* This class is similar to MyApp instead it
returns Scaffold Widget */
class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? super.key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      // Sets the content to the
      // center of the application page
      body: const Center(
          // Sets the content of the Application
          child: Text(
        'Welcome to GeeksForGeeks!',
      )),
    );
  }
}
*/


/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the froot of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/