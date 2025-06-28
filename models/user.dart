class User {
  final String id;
  final String fullName;
  final String nik;
  final String skNumber;
  final String email;
  final bool isVerified;

  User({
    required this.id,
    required this.fullName,
    required this.nik,
    required this.skNumber,
    required this.email,
    required this.isVerified,
  });
}
