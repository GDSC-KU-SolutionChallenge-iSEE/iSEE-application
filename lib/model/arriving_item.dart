class ArrivingItem {
  final int routeId;
  final String routeName;
  final int term;
  final double x;
  final double y;
  final String firstArriveMsg;
  final String secondArriveMsg;

  ArrivingItem(
      {required this.routeId,
      required this.routeName,
      required this.term,
      required this.x,
      required this.y,
      required this.firstArriveMsg,
      required this.secondArriveMsg});

  factory ArrivingItem.fromJson(Map<String, dynamic> json) {
    return ArrivingItem(
        routeId: int.parse(json['route_id']),
        routeName: json['route_name'] as String,
        term: json['route_arrive_term'] as int,
        x: json['x'] as double,
        y: json['y'] as double,
        firstArriveMsg: json['first_arrive_msg'] as String,
        secondArriveMsg: json['sec_arrive_msg'] as String);
  }
}
