import 'package:equatable/equatable.dart';
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
    return AppointmentModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dateTime: json['dateTime'] != null
          ? DateTime.parse(json['dateTime'])
          : DateTime.now(),
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
      'dateTime': dateTime.toIso8601String(),
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
