import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/erros/exceptions.dart';
import 'package:tdd_tutorial/core/erros/failures.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/remote/datasource.dart';
import 'package:tdd_tutorial/src/authentication/data/repositories/authentication_repository_impl.dart';

class MockAuthenticationRemoteDatasource extends Mock
    implements AuthenticationRemoteDatasource {}

void main() {
  late AuthenticationRemoteDatasource remoteDatasource;
  late AuthenticationRepositoryImpl repositoryImpl;

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

      const TestException = APIException(
        message: 'Unknown Error Occurred',
        statusCode: 500,
      );

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
        'should return a [ServerFailure] when the call to the remote datasource is unsuccessful',
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
                ApiFailure(
                  message: TestException.message,
                  statusCode: TestException.statusCode,
                ),
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
}
