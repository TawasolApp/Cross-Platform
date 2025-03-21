import 'package:equatable/equatable.dart';

class Education extends Equatable {
  final String institution;
  final String? institutionPic; // New field for institution image URL
  final String degree;
  final String field;
  final String startDate;
  final String? endDate;
  final String description;
  final String grade;

  const Education({
    required this.institution,
    this.institutionPic, // Added here
    required this.degree,
    required this.field,
    required this.startDate,
    this.endDate,
    required this.description,
    required this.grade,
  });

  @override
  List<Object?> get props => [
        institution,
        institutionPic, // Include in props
        degree,
        field,
        startDate,
        endDate,
        description,
        grade,
      ];
}
