abstract class DashboardEvent {}

class LoadDashboard extends DashboardEvent {
  final String userId;

  LoadDashboard(this.userId);
}
