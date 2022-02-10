class Node {
  final String id;
  final String parentId;
  final String name;
  final String description;
  int position;
  final String iconName;

  Node({
    required this.id,
    required this.parentId,
    required this.name,
    required this.description,
    required this.position,
    required this.iconName,
  });

  factory Node.empty() {
    return Node(
      id: 'empty',
      parentId: 'empty',
      name: 'empty',
      description: 'empty',
      position: 0,
      iconName: 'empty',
    );
  }

  Node.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        parentId = json['parentId'],
        name = json['name'],
        description = json['description'],
        position = json['position'],
        iconName = json['iconName'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'parentId': parentId,
        'name': name,
        'description': description,
        'position': position,
        'iconName': iconName,
      };
}
