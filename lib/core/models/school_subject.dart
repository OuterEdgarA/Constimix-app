class SchoolSubject {
  const SchoolSubject({
    required this.idMateria,
    required this.isExtracurricular,
    required this.area,
    required this.semester,
    required this.group,
    required this.keyCode,
    required this.name,
    required this.evaluationType,
    this.startDate,
    this.endDate,
    this.description = '',
  });

  final String idMateria;
  final bool isExtracurricular;
  final int area;
  final int semester;
  final String group;
  final String keyCode;
  final String name;
  final String evaluationType;
  final DateTime? startDate;
  final DateTime? endDate;
  final String description;
  bool matchesSearch(String query) {
    final normalized = query.trim().toLowerCase();
    return normalized.isEmpty ||
        idMateria.toLowerCase().contains(normalized) ||
        keyCode.toLowerCase().contains(normalized) ||
        name.toLowerCase().contains(normalized);
  }
}
