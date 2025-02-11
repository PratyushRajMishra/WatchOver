import 'package:flutter/material.dart';
class GetCallLogsPage extends StatefulWidget {
  const GetCallLogsPage({super.key});

  @override
  State<GetCallLogsPage> createState() => _GetCallLogsPageState();
}

class _GetCallLogsPageState extends State<GetCallLogsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Call Logs'),
      ),
    );
  }
}
