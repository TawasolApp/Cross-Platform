class Company {
  final String id;
  final String name;
  final String description;
  final String website; // Website URL of the company
  final String? bannerUrl; // URL of the banner image
  final String? logoUrl; // URL of the logo image
  final String field; // Field of the company
  final int? followerCount; // Number of followers of the company
  final int? employeeCount; // Number of employees of the company
  final String location; // Location of the company
  final List<String> followerIds; // Store only IDs for efficiency


  Company({
    required this.id,
    required this.name,
    required this.description,
    required this.website,
    this.bannerUrl,
    this.logoUrl,
    required this.field,
    this.followerCount,
    this.employeeCount,
    required this.location,
    required this.followerIds,
  });
}