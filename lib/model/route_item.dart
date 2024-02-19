class RouteItem {
  final int routeId;
  final String routeName;
  final int term;

  RouteItem(
      {required this.routeId, required this.routeName, required this.term});

  factory RouteItem.fromJson(Map<String, dynamic> json) {
    return RouteItem(
      routeId: int.parse(json['route_id']),
      routeName: json['route_name'] as String,
      term: json['term'] as int,
    );
  }
}
