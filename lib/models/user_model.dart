class UserModel {
  final String uid;
  final String email;
  final String name;
  final String? phone;
  final String? gender;
  final String? photo;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.phone,
    this.gender,
    this.photo,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone ?? '',
      'gender': gender ?? '',
      if (photo != null) 'photo': photo,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      phone: map['phone'] ?? '',
      gender: map['gender'] ?? '',
      photo: map['photo'],
    );
  }
}
