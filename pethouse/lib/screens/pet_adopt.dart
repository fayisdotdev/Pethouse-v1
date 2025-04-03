import 'package:flutter/material.dart';
import '../models/pet.dart';

class PetAdoptPage extends StatelessWidget {
  final Pet pet;

  const PetAdoptPage({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adopt ${pet.name}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                pet.petImage,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(pet.name, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('Owner: ${pet.userName}'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: pet.isFriendly ? Colors.green[100] : Colors.red[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                pet.isFriendly ? 'Friendly Pet' : 'Not Friendly',
                style: TextStyle(
                  color: pet.isFriendly ? Colors.green[900] : Colors.red[900],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
