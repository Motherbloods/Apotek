class User {
  final String? id;
  final String? email;
  final String? fullname;
  final String? img;
  User({
    this.id,
    this.email,
    this.fullname,
    this.img,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      email: json['email'],
      fullname: json['fullname'],
      img: json['img'],
    );
  }
}
