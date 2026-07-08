bool hasMinLength(String value, [int min = 8]) => value.length >= min;

bool hasLetterAndNumber(String value) =>
    RegExp(r'(?=.*[A-Za-z])(?=.*\d)').hasMatch(value);

bool hasLowercase(String value) => RegExp(r'[a-z]').hasMatch(value);

bool hasUppercase(String value) => RegExp(r'[A-Z]').hasMatch(value);

bool hasDigitChar(String value) => RegExp(r'[0-9]').hasMatch(value);

bool hasSpecialChar(String value) =>
    RegExp(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]').hasMatch(value);
