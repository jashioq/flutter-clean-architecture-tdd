import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/erros/exceptions.dart';
import 'package:tdd_tutorial/core/erros/failures.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/remote/datasource.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

class MockAuthenticationRemoteDatasource extends Mock
    implements AuthenticationRemoteDatasource {}

void main() {
  late AuthenticationRemoteDatasource remoteDatasource;
  late AuthenticationRepositoryImpl repositoryImpl;

  const TestException = APIException(
    message: 'Unknown Error Occurred',
    statusCode: 500,
  );

  setUp(
    () {
      remoteDatasource = MockAuthenticationRemoteDatasource();
      repositoryImpl = AuthenticationRepositoryImpl(remoteDatasource);
    },
  );

  group(
    'createUser',
    () {
      const createdAt = 'test.createdAt';
      const name = 'test.name';
      const avatar = 'test.avatar';

      test(
        'should call [RemoteDatasource.createUser] and complete successfully '
        'when the call to the remote datasource is successful',
        () async {
          when(
            () => remoteDatasource.createUser(
              createdAt: any(named: 'createdAt'),
              name: any(named: 'name'),
              avatar: any(named: 'avatar'),
            ),
          ).thenAnswer((_) async => Future.value());

          final result = await repositoryImpl.createUser(
              createdAt: createdAt, name: name, avatar: avatar);

          expect(result, equals(const Right(null)));
          verify(() => remoteDatasource.createUser(
              createdAt: createdAt, name: name, avatar: avatar)).called(1);
          verifyNoMoreInteractions(remoteDatasource);
        },
      );

      test(
        'should return a [APIFailure] when the call to the remote datasource is unsuccessful',
        () async {
          when(
            () => remoteDatasource.createUser(
              createdAt: any(named: 'createdAt'),
              name: any(named: 'name'),
              avatar: any(named: 'avatar'),
            ),
          ).thenThrow(TestException);

          final result = await repositoryImpl.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          );

          expect(
            result,
            equals(
              Left(
                APIFailure.fromException(TestException),
              ),
            ),
          );

          verify(
            () => remoteDatasource.createUser(
              createdAt: createdAt,
              name: name,
              avatar: avatar,
            ),
          ).called(1);

          verifyNoMoreInteractions(remoteDatasource);
        },
      );
    },
  );

  group(
    'getUsers',
    () {
      test(
        'should call [RemoteDatasource.getUsers], complete successfully '
        'when the call to the remote datasource is successful and return [List<User>]',
        () async {
          when(() => remoteDatasource.getUsers()).thenAnswer(
            (_) async => [],
          );

          final result = await repositoryImpl.getUsers();

          expect(result, isA<Right<dynamic, List<User>>>());

          verify(() => remoteDatasource.getUsers()).called(1);

          verifyNoMoreInteractions(remoteDatasource);
        },
      );

      test(
        'should return a [APIFailure] when the call to the remote datasource is unsuccessful',
        () async {
          when(() => remoteDatasource.getUsers()).thenThrow(TestException);

          final result = await repositoryImpl.getUsers();

          expect(
            result,
            equals(
              Left(
                APIFailure.fromException(TestException),
              ),
            ),
          );

          verify(() => remoteDatasource.getUsers()).called(1);

          verifyNoMoreInteractions(remoteDatasource);
        },
      );
    },
  );
}
