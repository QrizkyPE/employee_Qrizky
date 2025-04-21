import 'package:firebase_database/firebase_database.dart';

class KaryawanService {
  final DatabaseReference _karyawanRef =
      FirebaseDatabase.instance.ref('karyawan');

  // Get
  Stream<DatabaseEvent> getKaryawanStream() {
    return _karyawanRef.onValue;
  }

  // Add
  Future<void> addKaryawan(String jabatan, String nama) async {
    try {
      final newKaryawanRef = _karyawanRef.push();
      await newKaryawanRef.set({
        'position': jabatan,
        'name': nama,
        'createdAt': ServerValue.timestamp,
      });
    } catch (e) {
      throw Exception('Failed to add karyawan: $e');
    }
  }

  // Delete
  Future<void> deleteKaryawan(String key) async {
    try {
      await _karyawanRef.child(key).remove();
    } catch (e) {
      throw Exception('Failed to delete karyawan: $e');
    }
  }
}
