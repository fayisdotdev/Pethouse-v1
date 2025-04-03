import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../models/pet.dart';
import '../models/adoption.dart';
import '../providers/adoption_provider.dart';

class AdoptPage extends StatefulWidget {
  final List<Pet> pets;
  const AdoptPage({super.key, required this.pets});

  @override
  State<AdoptPage> createState() => _AdoptPageState();
}

class _AdoptPageState extends State<AdoptPage> {
  final _formKey = GlobalKey<FormState>();
  final List<Pet> selectedPets = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _petsController = TextEditingController();
  String name = '';
  int age = 0;
  String gender = 'Male';
  int numberOfPets = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _petsController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      name = _nameController.text;
      age = int.tryParse(_ageController.text) ?? 0;
      numberOfPets = int.tryParse(_petsController.text) ?? 0;

      try {
        final selectedPetsData =
            selectedPets
                .map(
                  (pet) => {
                    'id': pet.id,
                    'name': pet.name,
                    'isFriendly': pet.isFriendly,
                  },
                )
                .toList();

        final adoption = Adoption(
          name: name,
          age: age,
          gender: gender,
          numberOfPets: numberOfPets,
          selectedPets: selectedPetsData,
          applicationDate: DateTime.now(),
        );

        await context.read<AdoptionProvider>().submitAdoption(adoption);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Application submitted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error submitting application: $e'),
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
        title: const Text('Adopt a Pet'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<AdoptionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Your Name',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value?.isEmpty ?? true
                              ? 'Please enter your name'
                              : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  value: gender,
                  items:
                      ['Male', 'Female', 'Other']
                          .map(
                            (g) => DropdownMenuItem(value: g, child: Text(g)),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => gender = value);
                    }
                  },
                  validator:
                      (value) =>
                          value == null ? 'Please select your gender' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _petsController,
                  decoration: const InputDecoration(
                    labelText: 'Number of Pets you have',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number of pets';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Pets to Adopt:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...widget.pets.map(
                  (pet) => CheckboxListTile(
                    title: Text(pet.name),
                    subtitle: Text(
                      pet.isFriendly ? 'Friendly' : 'Not Friendly',
                    ),
                    secondary: CircleAvatar(
                      backgroundImage: NetworkImage(pet.petImage),
                    ),
                    value: selectedPets.contains(pet),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value ?? false) {
                          selectedPets.add(pet);
                        } else {
                          selectedPets.remove(pet);
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit Application'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
