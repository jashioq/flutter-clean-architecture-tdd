import 'package:get_it/get_it.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/remote/datasource.dart';
import 'package:tdd_tutorial/src/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:http/http.dart' as http;

final serviceLocator = GetIt.instance;

Future<void> init() async {
  serviceLocator
  // App logic
    ..registerFactory(
      () => AuthenticationCubit(
        createUser: serviceLocator(),
        getUsers: serviceLocator(),
      ),
    )

    // Use cases
    ..registerLazySingleton(() => CreateUser(serviceLocator()))
    ..registerLazySingleton(() => GetUsers(serviceLocator()))

    // Repositories
    ..registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepositoryImpl(serviceLocator()))

    // Data sources
    ..registerLazySingleton<AuthenticationRemoteDatasource>(
        () => AuthenticationRemoteDatasourceImpl(serviceLocator()))

    // External dependencies
      ..registerLazySingleton(http.Client.new);
}
