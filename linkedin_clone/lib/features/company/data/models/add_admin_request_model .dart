class AddAdminRequestModel {
  final String newUserId;

  AddAdminRequestModel({required this.newUserId});

  Map<String, dynamic> toJson() {
    return {
      "newUserId": newUserId,
    };
  }
}
