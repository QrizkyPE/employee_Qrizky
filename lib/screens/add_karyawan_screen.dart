import 'package:flutter/material.dart';
import '../services/karyawan_service.dart';

class AddKaryawanScreen extends StatefulWidget {
  const AddKaryawanScreen({super.key});

  @override
  State<AddKaryawanScreen> createState() => _AddKaryawanScreenState();
}

class _AddKaryawanScreenState extends State<AddKaryawanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _jabatanController = TextEditingController();
  final _namaController = TextEditingController();
  final KaryawanService _karyawanService = KaryawanService();
  bool _isLoading = false;

  @override
  void dispose() {
    _jabatanController.dispose();
    _namaController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _karyawanService.addKaryawan(
          _jabatanController.text,
          _namaController.text,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Karyawan berhasil ditambahkan')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Karyawan'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _jabatanController,
                decoration: const InputDecoration(
                  labelText: 'Jabatan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jabatan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
