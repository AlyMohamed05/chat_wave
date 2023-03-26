import 'package:chat_wave/core/data/db/chat_wave_db.dart';
import 'package:chat_wave/core/data/network/auth_interceptor.dart';
import 'package:chat_wave/core/data/secure_local_storage_impl.dart';
import 'package:chat_wave/core/data/token_manager_impl.dart';
import 'package:chat_wave/core/domain/secure_local_storage.dart';
import 'package:chat_wave/core/domain/token_manager.dart';
import 'package:chat_wave/core/event/data/event_repository_impl.dart';
import 'package:chat_wave/core/event/domain/event_repository.dart';
import 'package:chat_wave/home/data/repository/friend_repository_impl.dart';
import 'package:chat_wave/home/domain/repository/friend_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupServiceLocator() {
  locator.registerLazySingleton<Dio>(_configureDioClient);
  locator.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  locator.registerLazySingleton<SecureStorage>(() => SecureStorageImpl());
  locator.registerSingletonAsync<TokenManager>(
    () async {
      final manager = TokenManagerImpl();
      await manager.init();
      return manager;
    },
  );
  locator.registerSingletonWithDependencies(
    () => AuthInterceptor(),
    dependsOn: [TokenManager],
  );

  locator.registerSingletonAsync<ChatWaveDb>(
    () async {
      return await ChatWaveDb.initializeDb();
    },
  );

  locator.registerLazySingleton<FriendRepository>(
    () {
      final db = locator<ChatWaveDb>();
      return FriendRepositoryImpl(db);
    },
  );

  locator.registerLazySingleton<EventRepository>(
    () {
      final tokenManager = locator<TokenManager>();
      return EventRepositoryImpl(tokenManager);
    },
  );
}

Dio _configureDioClient() {
  final dio = Dio();
  dio.options.validateStatus = (_) => true;
  dio.options.responseType = ResponseType.json;
  final interceptor = locator<AuthInterceptor>();
  dio.interceptors.add(interceptor);
  return dio;
}
