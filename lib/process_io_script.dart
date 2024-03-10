import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

class ProcessInteractionScreen extends StatefulWidget {
  const ProcessInteractionScreen({super.key});

  @override
  State<ProcessInteractionScreen> createState() => _ProcessInteractionScreenState();
}

class _ProcessInteractionScreenState extends State<ProcessInteractionScreen> {
  final TextEditingController _controller = TextEditingController();
  String processOutput = "";
  Process? process;
  
  @override
  void initState() {
    super.initState();
    startMonitering();
  }

  @override
  void dispose() {
    process?.kill();
    super.dispose();
  }

  Future<void> startMonitering() async {
    var scriptPath = 'assets/automate.exe';
    process = await Process.start(scriptPath, []);

    process!.stdout.transform(utf8.decoder).listen((output) {
      setState(() {
        processOutput += "\n$output";
      });
    });

    process!.exitCode.then((_) {
      setState(() {
        processOutput += "\nMonitoring completed";
      });
    });

  }

  void sendInputToProcess() {
    process?.stdin.writeln(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Process Interaction"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Text(processOutput),
            ),
          ),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Enter input for the process",
            ),
          ),
          ElevatedButton(
            onPressed: sendInputToProcess,
            child: Text("Send"),
          ),
        ],
      ),
    );
  }
}
