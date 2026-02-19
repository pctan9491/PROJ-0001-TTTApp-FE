class User {
  final String id;
  final String name;
  final String email;
  final String gender;
  final String? profilePictureUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    this.profilePictureUrl,
  });

  // Factory constructor for creating a dummy user
  factory User.dummy() {
    return const User(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      gender: 'Male',
      profilePictureUrl: 'https://i.pravatar.cc/150?img=11',
    );
  }
}