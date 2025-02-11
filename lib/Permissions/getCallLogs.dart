import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class GetCallLogsPage extends StatefulWidget {
  const GetCallLogsPage({super.key});

  @override
  State<GetCallLogsPage> createState() => _GetCallLogsPageState();
}

class _GetCallLogsPageState extends State<GetCallLogsPage> {
  List<CallLogEntry> callLogs = [];

  @override
  void initState() {
    super.initState();
    fetchCallLogs();
  }

  Future<void> fetchCallLogs() async {
    if (await Permission.phone.request().isGranted &&
        await Permission.contacts.request().isGranted) {
      Iterable<CallLogEntry> logs = await CallLog.get();
      setState(() {
        callLogs = logs.toList();
      });
    } else {
      print("Permission Denied");
    }
  }

  String formatDuration(int? seconds) {
    if (seconds == null) return "0 sec";
    if (seconds < 60) return "$seconds sec";
    return "${(seconds / 60).floor()} min ${seconds % 60} sec";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Logs'),
        centerTitle: true,
      ),
      body: callLogs.isEmpty
          ? const Center(child: Text('Fetching Call logs...'))
          : ListView.builder(
        itemCount: callLogs.length,
        itemBuilder: (context, index) {
          CallLogEntry log = callLogs[index];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(
                  log.callType == CallType.missed
                      ? Icons.call_missed
                      : log.callType == CallType.incoming
                      ? Icons.call_received
                      : Icons.call_made,
                  color: Colors.white,
                ),
              ),
              title: Text(
                log.name ?? "Unknown",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Phone: ${log.number ?? "Unknown"}"),
                  Text("Duration: ${formatDuration(log.duration)}"),
                  Text("Date: ${DateTime.fromMillisecondsSinceEpoch(log.timestamp ?? 0)}"),
                ],
              ),
              trailing: Icon(
                log.callType == CallType.missed ? Icons.warning : Icons.phone,
                color: log.callType == CallType.missed ? Colors.red : Colors.green,
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          );
        },
      ),
    );
  }
}
