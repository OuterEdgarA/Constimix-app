class SchoolSubject {
  const SchoolSubject({
    required this.idMateria,
    required this.isExtracurricular,
    required this.area,
    required this.semester,
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
  final String keyCode;
  final String name;
  final String evaluationType;
  final DateTime? startDate;
  final DateTime? endDate;
  final String description;
}
