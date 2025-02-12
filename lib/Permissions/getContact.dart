import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class GetContactPage extends StatefulWidget {
  const GetContactPage({Key? key}) : super(key: key);

  @override
  State<GetContactPage> createState() => _GetContactPageState();
}

class _GetContactPageState extends State<GetContactPage> {
  late Future<List<Contact>> _contactsFuture;

  @override
  void initState() {
    super.initState();
    _contactsFuture = requestPermissionAndFetchContacts();
  }

  Future<List<Contact>> requestPermissionAndFetchContacts() async {
    PermissionStatus status = await Permission.contacts.status;

    if (!status.isGranted) {
      status = await Permission.contacts.request();
    }

    if (status.isGranted) {
      return FastContacts.getAllContacts();
    } else {
      showPermissionDeniedSnackBar();
      return [];
    }
  }

  void showPermissionDeniedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "[ACCESS DENIED] Contacts permission required!",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Terminal background
      appBar: AppBar(
        leading: BackButton(
          color: Colors.green,
        ),
        title: const Text(
          'Contacts',
          style: TextStyle(
            color: Colors.greenAccent,
            fontFamily: 'Courier',
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: FutureBuilder<List<Contact>>(
          future: _contactsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Text(
                  "[FETCHING CONTACTS...]\n███████▒▒▒▒▒▒▒▒▒▒▒▒",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: 'Courier',
                    fontSize: 18,
                  ),
                ),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "[ERROR] Failed to load contacts",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontFamily: 'Courier',
                    fontSize: 18,
                  ),
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "[NO CONTACTS FOUND] OR [PERMISSION DENIED]",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: 'Courier',
                    fontSize: 18,
                  ),
                ),
              );
            }

            List<Contact> sortedContacts = snapshot.data!;
            sortedContacts.sort((a, b) =>
                (a.displayName.isNotEmpty ? a.displayName : "Unknown")
                    .toLowerCase()
                    .compareTo((b.displayName.isNotEmpty ? b.displayName : "Unknown").toLowerCase()));

            return ListView.builder(
              itemCount: sortedContacts.length,
              itemBuilder: (context, index) {
                Contact contact = sortedContacts[index];

                return Card(
                  color: Colors.black, // Black terminal theme
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.greenAccent, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.greenAccent.withOpacity(0.2),
                      radius: 28,
                      child: const Icon(Icons.person, color: Colors.greenAccent),
                    ),
                    title: Text(
                      contact.displayName.isNotEmpty ? contact.displayName : 'Unknown Number',
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
                          if (contact.phones.isNotEmpty)
                            Row(
                              children: [
                                const Icon(Icons.phone, size: 16, color: Colors.greenAccent),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    contact.phones.map((e) => e.number).join(', '),
                                    style: const TextStyle(color: Colors.greenAccent, fontFamily: 'Courier'),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          if (contact.emails.isNotEmpty)
                            Row(
                              children: [
                                const Icon(Icons.email, size: 16, color: Colors.greenAccent),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    contact.emails.map((e) => e.address).join(', '),
                                    style: const TextStyle(color: Colors.greenAccent, fontFamily: 'Courier'),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
