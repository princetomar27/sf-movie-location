import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Internal Server Exception'});
  @override
  List<Object?> get props => [message];
}

class PermissionFailure extends Failure {
  const PermissionFailure({required super.message});
}

class UserNotExistFailure extends Failure {
  const UserNotExistFailure({super.message = 'Invalid credentials'});
}
