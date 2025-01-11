class UserState {
  final String? email;

  UserState({this.email});

  UserState copyWith({String? email}) {
    return UserState(
      email: email ?? this.email,
    );
  }

  @override
  String toString() {
    return 'UserState(email: $email)';
  }
}
