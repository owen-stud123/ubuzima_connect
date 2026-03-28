import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboard extends DashboardEvent {
  final String userId;

  const LoadDashboard(this.userId);

  @override
  List<Object?> get props => [userId];
}

class RefreshDashboard extends DashboardEvent {
  final String userId;

  const RefreshDashboard(this.userId);

  @override
  List<Object?> get props => [userId];
}
