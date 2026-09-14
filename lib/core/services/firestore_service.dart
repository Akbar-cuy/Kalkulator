import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Referensi ke koleksi 'workouts' di Firestore
  final CollectionReference _workoutCollection =
      FirebaseFirestore.instance.collection('workouts');

  // CREATE: Tambah jadwal latihan baru
  Future<void> tambahWorkout({
    required String namaKegiatan,
    required int targetRepetisi,
    required int durasiMenit,
    required String hari,
  }) async {
    await _workoutCollection.add({
      'nama_kegiatan': namaKegiatan,
      'target_repetisi': targetRepetisi,
      'durasi_menit': durasiMenit,
      'hari': hari,
      'status_selesai': false,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  // READ: Ambil aliran data realtime (digunakan oleh StreamBuilder)
  Stream<QuerySnapshot> getWorkoutsStream() {
    return _workoutCollection
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  // UPDATE: Ubah data latihan atau status selesai
  Future<void> updateWorkout(String idDoc, Map<String, dynamic> dataBaru) async {
    await _workoutCollection.doc(idDoc).update(dataBaru);
  }

  // DELETE: Hapus data latihan berdasarkan ID dokumen
  Future<void> hapusWorkout(String idDoc) async {
    await _workoutCollection.doc(idDoc).delete();
  }
}