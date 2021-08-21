class DataTutuyoz {
  String userName;
  String email;
  String image;
  DataTutuyoz(
      {required this.userName, required this.email, required this.image});
  factory DataTutuyoz.fromMap(Map data) {
    return DataTutuyoz(
        userName: data["userName"] ?? "",
        email: data["email"] ?? "",
        image: data["image"] ?? "");
  }
}
