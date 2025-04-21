import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../services/karyawan_service.dart';
import 'add_karyawan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final KaryawanService _karyawanService = KaryawanService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Karyawan'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _karyawanService.getKaryawanStream(),
        builder: (context, snapshot) {
          final data = snapshot.data?.snapshot.value;
          if (data == null || (data as Map).isEmpty) {
            return const Center(child: Text('Belum ada data karyawan'));
          }

          final karyawanMap = Map<String, dynamic>.from(data);
          final karyawanList = karyawanMap.entries.toList();

          return ListView.builder(
            itemCount: karyawanList.length,
            itemBuilder: (context, index) {
              final entry = karyawanList[index];
              final key = entry.key;
              final karyawan = Map<String, dynamic>.from(entry.value);

              return ListTile(
                title: Text(karyawan['name'] ?? 'No name'),
                subtitle:
                    Text('Jabatan: ${karyawan['position'] ?? 'No jabatan'}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Konfirmasi'),
                          content: const Text(
                              'Apakah anda yakin ingin menghapus karyawan ini?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Batal'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Hapus'),
                              onPressed: () {
                                _karyawanService.deleteKaryawan(key);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddKaryawanScreen()),
          );
        },
        tooltip: 'Tambah Karyawan',
        child: const Icon(Icons.add),
      ),
    );
  }
}
