import 'dart:typed_data';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class GetContactPage extends StatefulWidget {
  const GetContactPage({Key? key}) : super(key: key);

  @override
  State<GetContactPage> createState() => _GetContactPageState();
}

class _GetContactPageState extends State<GetContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: FutureBuilder<List<Contact>>(
          future: getContacts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: Text('Fetching contacts...'));
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Failed to load contacts"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No contacts found"));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Contact contact = snapshot.data![index];

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 28,
                    child: Icon(Icons.person),
                    ),
                    title: Text(
                      contact.displayName.isNotEmpty
                          ? contact.displayName
                          : 'Unknown Number',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
                                const Icon(Icons.phone, size: 16, color: Colors.grey),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    contact.phones.toString(),
                                    style: const TextStyle(color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          if (contact.emails.isNotEmpty)
                            Row(
                              children: [
                                const Icon(Icons.email, size: 16, color: Colors.grey),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    contact.emails.toString(),
                                    style: const TextStyle(color: Colors.grey),
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

  Future<List<Contact>> getContacts() async {
    bool isGranted = await Permission.contacts.status.isGranted;
    if (!isGranted) {
      isGranted = await Permission.contacts.request().isGranted;
    }
    if (isGranted) {
      return await FastContacts.getAllContacts();
    }
    return [];
  }
}
