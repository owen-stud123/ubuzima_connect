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
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firebaseFirestore
            .collection(_appointmentsCollection)
            .where('userId', isEqualTo: userId)
            .get();
    return snapshot.docs
        .map((doc) => AppointmentModel.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<AppointmentModel> getAppointmentById(String appointmentId) async {
    final DocumentSnapshot<Map<String, dynamic>> doc = await _firebaseFirestore
        .collection(_appointmentsCollection)
        .doc(appointmentId)
        .get();
    if (doc.exists) {
      return AppointmentModel.fromJson(doc.data()!);
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
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firebaseFirestore
            .collection(_appointmentsCollection)
            .where('userId', isEqualTo: userId)
            .where('dateTime', isGreaterThan: Timestamp.now())
            .orderBy('dateTime')
            .get();
    return snapshot.docs
        .map((doc) => AppointmentModel.fromJson(doc.data()))
        .toList();
  }
}
