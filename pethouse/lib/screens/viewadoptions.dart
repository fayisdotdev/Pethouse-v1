import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ViewAdoptionsPage extends StatelessWidget {
  const ViewAdoptionsPage({super.key});

  Future<void> _cancelAdoption(BuildContext context, String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cancel Adoption'),
            content: const Text(
              'Are you sure you want to cancel this adoption application?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Yes'),
              ),
            ],
          ),
    );

    if (confirm ?? false) {
      try {
        await FirebaseFirestore.instance
            .collection('adoptions')
            .doc(docId)
            .delete();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Adoption application cancelled successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error cancelling adoption: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adoption Applications'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('adoptions').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No adoption applications found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final applications = data['applications'] as List<dynamic>;

              return Column(
                children:
                    applications.map<Widget>((application) {
                      final DateTime applicationDate = DateTime.parse(
                        application['applicationdate'],
                      );
                      final formattedDate = DateFormat(
                        'MMM dd, yyyy',
                      ).format(applicationDate);

                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ExpansionTile(
                          title: Text(application['Name']),
                          subtitle: Text('Applied on: $formattedDate'),
                          children: [
                            ListTile(
                              title: const Text('Personal Information'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Age: ${application['Age']}'),
                                  Text('Gender: ${application['Gender']}'),
                                  Text(
                                    'Current Pets: ${application['NumberOfPets']}',
                                  ),
                                ],
                              ),
                            ),
                            const ListTile(title: Text('Selected Pets')),
                            ...(application['selectedpets'] as List<dynamic>)
                                .map(
                                  (pet) => ListTile(
                                    leading: Icon(
                                      pet['isFriendly']
                                          ? Icons.pets
                                          : Icons.warning,
                                      color:
                                          pet['isFriendly']
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                    title: Text(pet['name']),
                                    subtitle: Text(
                                      pet['isFriendly']
                                          ? 'Friendly'
                                          : 'Not Friendly',
                                    ),
                                  ),
                                ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed:
                                    () => _cancelAdoption(context, doc.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Cancel Application'),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
