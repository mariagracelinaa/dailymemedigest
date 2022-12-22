class Profile {
  int id;
  String username;
  String first_name;
  String last_name;
  String register_date;
  String avatar;
  int name_hidden;

  Profile(
      {required this.id,
      required this.username,
      required this.first_name,
      required this.last_name,
      required this.register_date,
      required this.avatar,
      required this.name_hidden});
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      username: json['username'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      register_date: json['register_date'],
      avatar: json['avatar_image'],
      name_hidden: json['name_hidden'],
    );
  }
}
