import 'package:equatable/equatable.dart';

class AppointmentEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime dateTime;
  final String status;
  final String? professionalName;
  final String? location;

  const AppointmentEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.status,
    this.professionalName,
    this.location,
  });

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
