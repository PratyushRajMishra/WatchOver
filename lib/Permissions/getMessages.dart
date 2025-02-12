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
        SnackBar(
          content: const Text(
            "[ACCESS DENIED] SMS permission required!",
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
  }

  String formatTimestamp(int? timestamp) {
    if (timestamp == null) return "Unknown time";
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Terminal background
      appBar: AppBar(
        leading: BackButton(
          color: Colors.green,
        ),
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.greenAccent,
            fontFamily: 'Courier',
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
        child: Text(
          "[FETCHING MESSAGES...]\n███████▒▒▒▒▒▒▒▒▒▒▒▒",
          style: TextStyle(
            color: Colors.greenAccent,
            fontFamily: 'Courier',
            fontSize: 18,
          ),
        ),
      )
          : messages.isNotEmpty
          ? ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return Card(
            color: Colors.black, // Black terminal theme
            elevation: 4,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.greenAccent, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.address ?? "Unknown Sender",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.greenAccent,
                      fontFamily: 'Courier',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message.body ?? "No content",
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontFamily: 'Courier',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatTimestamp(message.date),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: 'Courier',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      )
          : const Center(
        child: Text(
          "[ NO MESSAGES FOUND ]",
          style: TextStyle(
            color: Colors.greenAccent,
            fontFamily: 'Courier',
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
