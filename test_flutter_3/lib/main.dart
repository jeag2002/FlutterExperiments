import 'dart:async';
import 'dart:convert';
import 'dart:developer';

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
      title: 'Graph Application/Prediction',
      theme: themeData,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Graph Application/Prediction'),
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

  final Color fOneColor = const Color.fromARGB(255, 0, 0, 255);
  final Color fTwoColor = const Color.fromARGB(255, 0, 255, 255);

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

// ignore: camel_case_types
class predictionOpenApi {
  Future<String?> getOpenAiApi(List<double> query) async {
    var uri = Uri.parse(
        'https://us-central1-aiplatform.googleapis.com/v1/projects/mygeminiproject/locations/us-central1/publishers/google/models/gemini-1.0-pro:streamGenerateContent?alt=sse');

    String listAsString = query.toString();
    String message =
        "is trend increasing/decreasing/stable/not noticeable? $listAsString";

    log("chatGPT message: $message");

    String apiKey =
        "<google cloud key>";

    var response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "contents": {
            "role": "user",
            "parts": {"text": message},
          },
          "safety_settings": {
            "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
            "threshold": "BLOCK_LOW_AND_ABOVE"
          },
          "generation_config": {"temperature": 0.2, "topP": 0.8, "topK": 40}
        }));

    if (response.statusCode == 200) {
      var body = response.body;
      body = body.substring("data :".length);
      log("body: $body");
      var chatResponse =
          jsonDecode(body)['candidates'][0]['content']['parts'][0]["text"];
      if (chatResponse.indexOf("increasing") != -1) {
        chatResponse = "increasing";
      } else if (chatResponse.indexOf("decreasing") != -1) {
        chatResponse = "decreasing";
      } else if (chatResponse.indexOf("stable") != -1) {
        chatResponse = "stable";
      } else if (chatResponse.indexOf("not noticeable") != -1) {
        chatResponse = "not noticeable";
      } else {
        chatResponse = "not evaluable";
      }
      return chatResponse;
    } else {
      var statusStr = response.statusCode.toString();
      log("status : $statusStr");
      var chatResponse = "not evaluable";
      return chatResponse;
    }
  }
}

class PredictionOpenAiService {
  final _api = predictionOpenApi();
  Future<String?> getPredictionTest(List<double> query) async {
    return _api.getOpenAiApi(query);
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
  final f1Points = <FlSpot>[];
  final f2Points = <FlSpot>[];

  String? predictionOne = "";
  String? predictionTwo = "";

  double xValue = 0;
  double step = 0.05;

  late Timer timer;

  final randomNumberService = RandomNumberService();
  final predictionOpenAiService = PredictionOpenAiService();

  void setPoints() async {
    final List<int>? values = await randomNumberService.getRandomNumbers();

    final listYf1 = f1Points.map((c) => c.y).toList();
    final listYf2 = f2Points.map((c) => c.y).toList();

    predictionOne = await predictionOpenAiService.getPredictionTest(listYf1);
    predictionTwo = await predictionOpenAiService.getPredictionTest(listYf2);

    f1Points.add(FlSpot(xValue, values![0].toDouble()));
    f2Points.add(FlSpot(xValue, values[1].toDouble()));
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      while (f1Points.length > limitCount) {
        f1Points.removeAt(0);
        f2Points.removeAt(0);
      }
      setState(() {
        setPoints();
      });
      xValue += step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return f2Points.isNotEmpty
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
                'graph 1: ${f1Points.last.y.toStringAsFixed(1)}',
                style: TextStyle(
                  color: widget.fOneColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'prediction graph 1: $predictionOne',
                style: TextStyle(
                  color: widget.fOneColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'graph 2: ${f2Points.last.y.toStringAsFixed(1)}',
                style: TextStyle(
                  color: widget.fTwoColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'prediction graph 2: $predictionTwo',
                style: TextStyle(
                  color: widget.fTwoColor,
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
                      minX: f1Points.first.x,
                      maxX: f1Points.last.x,
                      lineTouchData: const LineTouchData(enabled: false),
                      clipData: const FlClipData.all(),
                      gridData: const FlGridData(
                        show: true,
                        drawVerticalLine: false,
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        sinLine(f1Points),
                        cosLine(f2Points),
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
        colors: [widget.fOneColor.withOpacity(0), widget.fOneColor],
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
        colors: [widget.fTwoColor.withOpacity(0), widget.fTwoColor],
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
