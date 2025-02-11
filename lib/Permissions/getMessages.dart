import 'package:another_telephony/telephony.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date and time

class GetMessagesPage extends StatefulWidget {
  const GetMessagesPage({super.key});

  @override
  State<GetMessagesPage> createState() => _GetMessagesPageState();
}

class _GetMessagesPageState extends State<GetMessagesPage> {
  final Telephony telephony = Telephony.instance;
  List<SmsMessage> messages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSmsMessages();
  }

  Future<void> fetchSmsMessages() async {
    bool? permissionsGranted = await telephony.requestSmsPermissions;
    if (permissionsGranted != null && permissionsGranted) {
      List<SmsMessage> smsList = await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
      );
      setState(() {
        messages = smsList;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("SMS permission denied")),
      );
    }
  }

  String formatTimestamp(int? timestamp) {
    if (timestamp == null) return "Unknown time";
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read SMS Messages'),
      ),
      body: isLoading
          ? const Center(child: Text('Fetching messages...'))
          : messages.isNotEmpty
          ? ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return Card(
            margin: const EdgeInsets.symmetric(
                vertical: 8, horizontal: 12),
            elevation: 4,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                message.address ?? "Unknown Sender",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(message.body ?? "No content"),
                  const SizedBox(height: 8),
                  Text(
                    formatTimestamp(message.date),
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      )
          : const Center(child: Text('No messages found')),
    );
  }
}
