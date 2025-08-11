import 'package:dartz/dartz.dart';
import 'package:osc25/features/authentication/data/datasources/remote/auth_data_source.dart';
import 'package:osc25/features/authentication/data/models/response/login_failure_response.dart';
import 'package:osc25/features/authentication/data/models/response/login_success_response.dart';

class AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepository(this._authDataSource);

  Future<Either<LoginFailureResponse, LoginSuccessResponse>> login(
    String email,
    String password,
  ) {
    return _authDataSource.login(email, password);
  }
}
