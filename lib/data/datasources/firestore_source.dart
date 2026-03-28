import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ubuzima_connect/data/models/appointment_model.dart';

abstract class FirestoreSource {
  Future<List<AppointmentModel>> getAppointments(String userId);
  Future<AppointmentModel> getAppointmentById(String appointmentId);
  Future<void> createAppointment(AppointmentModel appointment);
  Future<void> updateAppointment(AppointmentModel appointment);
  Future<void> deleteAppointment(String appointmentId);
  Future<List<AppointmentModel>> getUpcomingAppointments(String userId);
}

class FirestoreSourceImpl implements FirestoreSource {
  final FirebaseFirestore _firebaseFirestore;
  static const String _appointmentsCollection = 'appointments';

  FirestoreSourceImpl({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  @override
  Future<List<AppointmentModel>> getAppointments(String userId) async {
    try {
      print('🔍 Querying Firestore for appointments with userId: $userId');
      final snapshot = await _firebaseFirestore
          .collection(_appointmentsCollection)
          .where('userId', isEqualTo: userId)
          .get();

      print('✅ Got ${snapshot.docs.length} documents from Firestore');

      final appointments = snapshot.docs.map((doc) {
        print('📄 Parsing document: ${doc.id}');
        return AppointmentModel.fromJson({
          ...doc.data(),
          'id': doc.id,
        });
      }).toList();

      print('✅ Parsed ${appointments.length} appointments');
      return appointments;
    } catch (e, stackTrace) {
      print('❌ Firestore query error: $e');
      print('📍 Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<AppointmentModel> getAppointmentById(String appointmentId) async {
    final doc = await _firebaseFirestore
        .collection(_appointmentsCollection)
        .doc(appointmentId)
        .get();

    if (doc.exists) {
      return AppointmentModel.fromJson({
        ...doc.data()!,
        'id': doc.id,
      });
    }

    throw Exception('Appointment not found');
  }

  @override
  Future<void> createAppointment(AppointmentModel appointment) async {
    await _firebaseFirestore
        .collection(_appointmentsCollection)
        .doc(appointment.id)
        .set(appointment.toJson());
  }

  @override
  Future<void> updateAppointment(AppointmentModel appointment) async {
    await _firebaseFirestore
        .collection(_appointmentsCollection)
        .doc(appointment.id)
        .update(appointment.toJson());
  }

  @override
  Future<void> deleteAppointment(String appointmentId) async {
    await _firebaseFirestore
        .collection(_appointmentsCollection)
        .doc(appointmentId)
        .delete();
  }

  @override
  Future<List<AppointmentModel>> getUpcomingAppointments(String userId) async {
    try {
      print('🔍 Querying upcoming appointments for userId: $userId');
      final snapshot = await _firebaseFirestore
          .collection(_appointmentsCollection)
          .where('userId', isEqualTo: userId)
          .get();

      print('✅ Got ${snapshot.docs.length} documents from Firestore');

      // Filter for upcoming appointments by comparing parsed DateTime
      final now = DateTime.now();
      final appointments = snapshot.docs
          .map((doc) => AppointmentModel.fromJson({
                ...doc.data(),
                'id': doc.id,
              }))
          .where((appointment) => appointment.dateTime.isAfter(now))
          .toList()
        ..sort((a, b) => a.dateTime.compareTo(b.dateTime)); // Sort by date

      print('✅ Filtered to ${appointments.length} upcoming appointments');
      return appointments;
    } catch (e, stackTrace) {
      print('❌ Error fetching upcoming appointments: $e');
      print('📍 Stack trace: $stackTrace');
      rethrow;
    }
  }
}
