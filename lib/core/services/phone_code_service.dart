class PhoneCode {
  const PhoneCode({
    required this.country,
    required this.dialCode,
    required this.flag,
  });

  final String country;
  final String dialCode;
  final String flag;

  String get label => '$flag $dialCode';
  String get fullLabel => '$flag $country ($dialCode)';
}

class PhoneCodeService {
  static const all = [
    PhoneCode(country: 'Mexico', dialCode: '+52', flag: '\u{1F1F2}\u{1F1FD}'),
    PhoneCode(country: 'United States', dialCode: '+1', flag: '\u{1F1FA}\u{1F1F8}'),
    PhoneCode(country: 'Spain', dialCode: '+34', flag: '\u{1F1EA}\u{1F1F8}'),
    PhoneCode(country: 'United Kingdom', dialCode: '+44', flag: '\u{1F1EC}\u{1F1E7}'),
    PhoneCode(country: 'Argentina', dialCode: '+54', flag: '\u{1F1E6}\u{1F1F7}'),
    PhoneCode(country: 'Brazil', dialCode: '+55', flag: '\u{1F1E7}\u{1F1F7}'),
    PhoneCode(country: 'Chile', dialCode: '+56', flag: '\u{1F1E8}\u{1F1F1}'),
    PhoneCode(country: 'Colombia', dialCode: '+57', flag: '\u{1F1E8}\u{1F1F4}'),
    PhoneCode(country: 'Peru', dialCode: '+51', flag: '\u{1F1F5}\u{1F1EA}'),
    PhoneCode(country: 'Venezuela', dialCode: '+58', flag: '\u{1F1FB}\u{1F1EA}'),
    PhoneCode(country: 'Guatemala', dialCode: '+502', flag: '\u{1F1EC}\u{1F1F9}'),
    PhoneCode(country: 'El Salvador', dialCode: '+503', flag: '\u{1F1F8}\u{1F1FB}'),
    PhoneCode(country: 'Honduras', dialCode: '+504', flag: '\u{1F1ED}\u{1F1F3}'),
    PhoneCode(country: 'Nicaragua', dialCode: '+505', flag: '\u{1F1F3}\u{1F1EE}'),
    PhoneCode(country: 'Costa Rica', dialCode: '+506', flag: '\u{1F1E8}\u{1F1F7}'),
    PhoneCode(country: 'Panama', dialCode: '+507', flag: '\u{1F1F5}\u{1F1E6}'),
    PhoneCode(country: 'Cuba', dialCode: '+53', flag: '\u{1F1E8}\u{1F1FA}'),
    PhoneCode(country: 'France', dialCode: '+33', flag: '\u{1F1EB}\u{1F1F7}'),
    PhoneCode(country: 'Germany', dialCode: '+49', flag: '\u{1F1E9}\u{1F1EA}'),
    PhoneCode(country: 'Italy', dialCode: '+39', flag: '\u{1F1EE}\u{1F1F9}'),
    PhoneCode(country: 'Japan', dialCode: '+81', flag: '\u{1F1EF}\u{1F1F5}'),
    PhoneCode(country: 'China', dialCode: '+86', flag: '\u{1F1E8}\u{1F1F3}'),
    PhoneCode(country: 'South Korea', dialCode: '+82', flag: '\u{1F1F0}\u{1F1F7}'),
    PhoneCode(country: 'India', dialCode: '+91', flag: '\u{1F1EE}\u{1F1F3}'),
  ];

  List<PhoneCode> get codes => all;
}
