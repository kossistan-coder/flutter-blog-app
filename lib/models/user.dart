class User {
  int? id;
  String? name;
  String? email;
  String? image;
  String? tel;
  String? token;

  User({this.id, this.name, this.email, this.image, this.tel, this.token});
  //covert json data to user model
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['user']['id'],
        name: json['user']['name'],
        email: json['user']['email'],
        image: json['user']['image'],
        tel: json['user']['tel'],
        token: json['token']);
  }
}
