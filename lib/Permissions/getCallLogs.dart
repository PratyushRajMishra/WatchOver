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
      showPermissionDeniedSnackBar();
    }
  }

  void showPermissionDeniedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "[ACCESS DENIED] Call log permission required!",
          style: TextStyle(
            color: Colors.greenAccent,
            fontFamily: 'Courier',
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.greenAccent, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  String formatDuration(int? seconds) {
    if (seconds == null) return "0 sec";
    if (seconds < 60) return "$seconds sec";
    return "${(seconds / 60).floor()} min ${seconds % 60} sec";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.green,
        ),
        title: const Text(
          'Call Logs',
          style: TextStyle(
            color: Colors.greenAccent,
            fontFamily: 'Courier',
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: callLogs.isEmpty
          ? const Center(
        child: Text(
          "[FETCHING CALL LOGS...]\n███████▒▒▒▒▒▒▒▒▒▒▒▒▒",
          style: TextStyle(
            color: Colors.greenAccent,
            fontFamily: 'Courier',
            fontSize: 18,
          ),
        ),
      )
          : ListView.builder(
        itemCount: callLogs.length,
        itemBuilder: (context, index) {
          CallLogEntry log = callLogs[index];

          return Card(
            color: Colors.black,
            elevation: 4,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.greenAccent, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.greenAccent.withOpacity(0.2),
                radius: 28,
                child: Icon(
                  log.callType == CallType.missed
                      ? Icons.call_missed
                      : log.callType == CallType.incoming
                      ? Icons.call_received
                      : Icons.call_made,
                  color: Colors.greenAccent,
                ),
              ),
              title: Text(
                log.name ?? "Unknown",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.greenAccent,
                  fontFamily: 'Courier',
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Phone: ${log.number ?? "Unknown"}",
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontFamily: 'Courier',
                      ),
                    ),
                    Text(
                      "Duration: ${formatDuration(log.duration)}",
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontFamily: 'Courier',
                      ),
                    ),
                    Text(
                      "Date: ${DateTime.fromMillisecondsSinceEpoch(log.timestamp ?? 0)}",
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontFamily: 'Courier',
                      ),
                    ),
                  ],
                ),
              ),
              trailing: Icon(
                log.callType == CallType.missed ? Icons.warning : Icons.phone,
                color: log.callType == CallType.missed ? Colors.red : Colors.greenAccent,
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          );
        },
      ),
    );
  }
}
