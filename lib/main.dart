import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:rattu_tota/process_io_script.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Automation Bot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Rattu Tota'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late OverlayEntry? _overlayEntry;


  void _showLoaderOverlay() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _overlayEntry = OverlayEntry(
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );
      Overlay.of(context)!.insert(_overlayEntry!);
    });
  }

  void _hideLoaderOverlay() {
    _overlayEntry!.remove();
  }

  void _showContentOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Container(
          width: 200,
          height: 200,
          color: Colors.grey.withOpacity(0.7),
          child: Center(
            child: Text(
              'Press Escape to exit',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideContentOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry =
          null; // Ensure to reset _overlayEntry to null after removal
    }
  }

  Future<void> startMonitering() async {
    var scriptPath = 'assets/tracking.exe';

    var process = await Process.start(scriptPath, []);

    _showLoaderOverlay();

    Future.delayed(Duration(seconds: 2), () {
      // Hide loader overlay and show content overlay
      _hideLoaderOverlay();
      _showContentOverlay();
    });

    await process.exitCode;
    _hideContentOverlay();

    print("Monitering completed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 75,
              child: ElevatedButton(
                onPressed: startMonitering,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.zero, // Remove default padding
                  alignment: Alignment.center, // Align button content to center
                ),
                child: Text('Create New'),
              ),
            ),
            SizedBox(width: 100), // Add some space between the buttons
            SizedBox(
              width: 150,
              height: 75,
              child: ElevatedButton(
                onPressed: () {
                  _showModal(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.zero, // Remove default padding
                  alignment: Alignment.center, // Align button content to center
                ),
                child: const Text('Run Script'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showModal(BuildContext context) {
    showModalBottomSheet(
      context: context, 
      builder: (BuildContext context) {
        return const ProcessInteractionScreen();
      }
    );
  }
}
