import 'package:chat_wave/domain/secure_local_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageImpl implements SecureStorage {
  final _storage = const FlutterSecureStorage();

  @override
  Future<String?> getAccessToken() async {
    return await _storage.read(key: SecureStorage.tokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: SecureStorage.refreshTokenKey);
  }

  @override
  Future<bool> hasRefreshToken() async {
    return await _storage.read(key: SecureStorage.refreshTokenKey) != null;
  }

  @override
  Future<bool> hasToken() async {
    return await _storage.read(key: SecureStorage.tokenKey) != null;
  }

  @override
  Future<void> saveRefreshToken(String refreshToken) async {
    return await _storage.write(
      key: SecureStorage.refreshTokenKey,
      value: refreshToken,
    );
  }

  @override
  Future<void> saveToken(String accessToken) async {
    return await _storage.write(
      key: SecureStorage.tokenKey,
      value: accessToken,
    );
  }
}
