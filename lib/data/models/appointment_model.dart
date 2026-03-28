import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ubuzima_connect/domain/entities/appointment_entity.dart';

class AppointmentModel extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime dateTime;
  final String status;
  final String? professionalName;
  final String? location;

  const AppointmentModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.status,
    this.professionalName,
    this.location,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    // Handle DateTime from either Firestore Timestamp or String format
    DateTime parseDateTime(dynamic dateValue) {
      if (dateValue is Timestamp) {
        return dateValue.toDate();
      } else if (dateValue is String) {
        return DateTime.parse(dateValue);
      }
      return DateTime.now();
    }

    return AppointmentModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ??
          json['patientName'] ??
          '', // Fallback for patientName
      description: json['description'] ?? '',
      dateTime: parseDateTime(
          json['dateTime'] ?? json['date']), // Handle both field names
      status: json['status'] ?? 'pending',
      professionalName: json['professionalName'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'dateTime': dateTime,
      'status': status,
      'professionalName': professionalName,
      'location': location,
    };
  }

  AppointmentEntity toEntity() {
    return AppointmentEntity(
      id: id,
      userId: userId,
      title: title,
      description: description,
      dateTime: dateTime,
      status: status,
      professionalName: professionalName,
      location: location,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        description,
        dateTime,
        status,
        professionalName,
        location,
      ];
}
