class StationItem {
  final int nodeId;
  final String nodeName;
  final double x;
  final double y;

  StationItem(
      {required this.nodeId,
      required this.nodeName,
      required this.x,
      required this.y});

  factory StationItem.fromJson(Map<String, dynamic> json) {
    return StationItem(
        nodeId: json['node_id'] as int,
        nodeName: json['node_name'] as String,
        x: json['x'] as double,
        y: json['y'] as double);
  }
}
