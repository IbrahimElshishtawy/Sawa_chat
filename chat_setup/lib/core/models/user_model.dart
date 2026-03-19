import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String? email;
  final String? description;
  final String? phone;
  final String role;
  final String? linkedin;
  final String? facebook;
  final String? instagram;
  final String? whatsapp;
  final String backgroundImage;
  final String? username;
  final String? profilePicture;
  final String? website;
  final int postsCount;
  final int followersCount;
  final int followingCount;

  // Professional fields
  final String? jobTitle;
  final String? company;
  final String? industry;
  final String? professionalBio;

  final String plan;
  final DateTime? planExpiry;

  UserModel({
    required this.profilePicture,
    this.website,
    required this.id,
    required this.name,
    this.email,
    this.description,
    this.phone,
    required this.role,
    this.username,
    this.linkedin,
    this.facebook,
    this.instagram,
    this.whatsapp,
    required this.backgroundImage,
    this.postsCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.jobTitle,
    this.company,
    this.industry,
    this.professionalBio,
    this.plan = 'free',
    this.planExpiry,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'],
      phone: map['phone'],
      description: map['description'],
      role: map['role'] ?? 'user',
      username: map['username'],
      profilePicture: map['profilePicture'],
      website: map['website'],
      backgroundImage: map['backgroundImage'] ?? '',
      postsCount: map['postsCount'] ?? 0,
      followersCount: map['followersCount'] ?? 0,
      followingCount: map['followingCount'] ?? 0,
      jobTitle: map['jobTitle'],
      company: map['company'],
      industry: map['industry'],
      professionalBio: map['professionalBio'],
      plan: map['plan'] ?? 'free',
      planExpiry: map['planExpiry'] != null
          ? (map['planExpiry'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'description': description,
      'username': username,
      'profilePicture': profilePicture,
      'website': website,
      'backgroundImage': backgroundImage,
      'postsCount': postsCount,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'jobTitle': jobTitle,
      'company': company,
      'industry': industry,
      'professionalBio': professionalBio,
      'plan': plan,
      'planExpiry': planExpiry,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? role,
    String? username,
    String? profilePicture,
    String? website,
    String? linkedin,
    String? facebook,
    String? description,
    String? instagram,
    String? whatsapp,
    String? backgroundImage,
    int? postsCount,
    int? followersCount,
    int? followingCount,
    String? jobTitle,
    String? company,
    String? industry,
    String? professionalBio,
    String? plan,
    DateTime? planExpiry,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      description: description ?? this.description,
      profilePicture: profilePicture ?? this.profilePicture,
      website: website ?? this.website,
      username: username ?? this.username,
      linkedin: linkedin ?? this.linkedin,
      facebook: facebook ?? this.facebook,
      instagram: instagram ?? this.instagram,
      whatsapp: whatsapp ?? this.whatsapp,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      postsCount: postsCount ?? this.postsCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      industry: industry ?? this.industry,
      professionalBio: professionalBio ?? this.professionalBio,
      plan: plan ?? this.plan,
      planExpiry: planExpiry ?? this.planExpiry,
    );
  }
}
