import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/erros/exceptions.dart';
import 'package:tdd_tutorial/core/utils/constants.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/remote/datasource.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDatasource remoteDatasource;

  setUp(
    () {
      client = MockClient();
      remoteDatasource = AuthenticationRemoteDatasourceImpl(client);
      registerFallbackValue(Uri());
    },
  );

  group(
    'createUser',
    () {
      test(
        'should complete succesfully when the status code is 200 or 201',
        () async {
          when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
            (_) async => http.Response('User created successfully', 201),
          );

          final methodCall = remoteDatasource.createUser;

          expect(
              methodCall(
                createdAt: 'createdAt',
                name: 'name',
                avatar: 'avatar',
              ),
              completes);

          verify(
            () => client.post(
              Uri.parse('$kBaseUrl$kCreateUserEndpoint'),
              body: jsonEncode(
                {
                  'createdAt': 'createdAt',
                  'name': 'name',
                  'avatar': 'avatar',
                },
              ),
            ),
          ).called(1);

          verifyNoMoreInteractions(client);
        },
      );
      test(
        'should return [APIException] when the status code is not 200 or 201',
        () async {
          when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
            (_) async => http.Response('Invalid parameter: name', 400),
          );

          final methodCall = remoteDatasource.createUser;

          expect(
            () async => methodCall(
              createdAt: 'createdAt',
              name: 'name',
              avatar: 'avatar',
            ),
            throwsA(
              const APIException(
                  message: 'Invalid parameter: name', statusCode: 400),
            ),
          );

          verify(
            () => client.post(
              Uri.parse('$kBaseUrl$kCreateUserEndpoint'),
              body: jsonEncode(
                {
                  'createdAt': 'createdAt',
                  'name': 'name',
                  'avatar': 'avatar',
                },
              ),
            ),
          ).called(1);

          verifyNoMoreInteractions(client);
        },
      );
    },
  );
  group(
    'getUsers',
    () {
      const testResponse = [UserModel.empty()];
      test(
        'should return a [List<UserModel>] and complete successfully when the status code is 200',
        () async {
          when(() => client.get(any())).thenAnswer(
            (_) async => http.Response(
              jsonEncode([testResponse.first.toMap()]),
              200,
            ),
          );

          final result = await remoteDatasource.getUsers();

          expect(
            result,
            testResponse,
          );

          verify(() => client.get(Uri.parse('$kBaseUrl$kGetUsersEndpoint')))
              .called(1);

          verifyNoMoreInteractions(client);
        },
      );

      test(
        'should throw [APIException] when the status code is not 200',
        () async {
          when(() => client.get(any())).thenAnswer(
            (_) async => http.Response('Server down', 500),
          );

          final methodCall = remoteDatasource.getUsers();

          expect(
            methodCall,
            throwsA(
              const APIException(message: 'Server down', statusCode: 500),
            ),
          );

          verify(() => client.get(Uri.parse('$kBaseUrl$kGetUsersEndpoint')))
              .called(1);

          verifyNoMoreInteractions(client);
        },
      );
    },
  );
}
