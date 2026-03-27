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

  /// Creates a copy of this entity with updated fields.
  /// Useful for updating specific fields while keeping others unchanged.
  AppointmentEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? dateTime,
    String? status,
    String? professionalName,
    String? location,
  }) {
    return AppointmentEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      professionalName: professionalName ?? this.professionalName,
      location: location ?? this.location,
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
