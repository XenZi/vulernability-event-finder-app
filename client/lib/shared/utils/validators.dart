String? validateRequiredField(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'This field is required';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email is required';
  }
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Password is required';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters long';
  }
  return null;
}

String? validateIPAddress(String? value) {
  final ipRegEx = RegExp(
    r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$',
  );

  if (value == null || value.trim().isEmpty) {
    return 'IP address is required';
  }
  if (!ipRegEx.hasMatch(value)) {
    return 'Invalid IP address';
  }

  final octets = value.split('.');
  for (final octet in octets) {
    final number = int.tryParse(octet);
    if (number == null || number < 0 || number > 255) {
      return 'Invalid IP address';
    }
  }

  return null;
}
