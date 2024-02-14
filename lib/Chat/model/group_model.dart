class Group {
  final String id;
  final String name;
  final List<String> memberEmails;

  Group({required this.id, required this.name, required this.memberEmails});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      memberEmails: List<String>.from(json['memberEmails']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'memberEmails': memberEmails,
    };
  }
}
