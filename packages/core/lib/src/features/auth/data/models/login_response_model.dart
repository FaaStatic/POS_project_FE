import 'package:json_annotation/json_annotation.dart';

import '../../../../constants/roles.dart';
import '../../domain/entities/session.dart';

part 'login_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class LoginResponseModel {
  const LoginResponseModel({
    required this.id,
    required this.username,
    required this.role,
    this.token,
    this.refreshToken,
    this.expiresIn,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => _$LoginResponseModelFromJson(json);

  final String id;
  final String username;
  final String role;
  final String? token;

  /// Empty for web clients: the backend moves it into the HttpOnly cookie.
  final String? refreshToken;
  final int? expiresIn;

  Session toEntity() => Session(userId: id, username: username, role: UserRole.parse(role));
}
