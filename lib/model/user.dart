class UserModel {
   String? fullName;
   String? studentId;
   String? imageUrl;
   String? specialization;
   String? phoneNumber;

  UserModel({
    this.fullName,
    this.studentId,
    this.imageUrl,
    this.specialization,
    this.phoneNumber,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : fullName = json['full_name'] as String?,
        studentId = json['student_id'] as String?,
        imageUrl = json['image_url'] as String?,
        specialization = json['specialization'] as String?,
        phoneNumber = json['phone_number'] as String?;

  Map<String, dynamic> toJson() => {
    'full_name' : fullName,
    'student_id' : studentId,
    'image_url' : imageUrl,
    'specialization' : specialization,
    'phone_number' : phoneNumber
  };
}