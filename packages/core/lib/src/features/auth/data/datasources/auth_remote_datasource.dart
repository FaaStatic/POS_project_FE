import '../../../../constants/api_paths.dart';
import '../../../../network/api_client.dart';
import '../models/login_response_model.dart';

class AuthRemoteDatasource {
  /// [bare] has no auth interceptor so refresh can never recurse into itself.
  const AuthRemoteDatasource({required this._api, required this._bare});

  final ApiClient _api;
  final ApiClient _bare;

  Future<LoginResponseModel> login(String username, String password) async => LoginResponseModel.fromJson(
        await _bare.post(ApiPaths.login, body: {'username': username, 'password': password}) as Map<String, dynamic>,
      );

  Future<LoginResponseModel> refresh(String? refreshToken) async => LoginResponseModel.fromJson(
        await _bare.post(ApiPaths.refresh, body: refreshToken == null ? <String, dynamic>{} : {'refresh_token': refreshToken})
            as Map<String, dynamic>,
      );

  Future<void> logout({String? refreshToken, String? fcmToken}) => _api.post(
        ApiPaths.logout,
        body: {
          'refresh_token': ?refreshToken,
          'fcm_token': ?fcmToken,
        },
      );
}
