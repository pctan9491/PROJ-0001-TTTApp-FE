
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

  // Convert Django GET /api/auth/me/ response into User Object
  factory User.fromMeResponse(Map<String, dynamic> response) {

    // 1. Retrieve User Object from JSON
    final user = response['user'] as Map<String, dynamic>;

    // 2. Retrieve Login Credential Object
    final credential =
        response['login_credential'] as Map<String, dynamic>?;

    // 3. Convert Gender values to FE format
    final genderCode =
        (user['gender'] ?? '').toString().toUpperCase();

    String gender;

    if (genderCode == 'M' || genderCode == 'MALE') {
      gender = 'Male';
    } else if (genderCode == 'F' || genderCode == 'FEMALE') {
      gender = 'Female';
    } else {
      gender = 'Other';
    }

    // 4. Create Flutter User Object
    return User(
      id: (user['user_ulid'] ?? user['id'] ?? '').toString(),
      name: '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}'.trim(),
      email: (credential?['email'] ?? '').toString(),
      gender: gender,
      profilePictureUrl: null,
    );
  }

  // Existing dummy data (can be removed later)
  factory User.dummy() {
    return const User(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      gender: 'Male',
    );
  }
}
