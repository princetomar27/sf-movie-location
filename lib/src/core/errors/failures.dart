import 'package:equatable/equatable.dart';
import '../network/error_message_model.dart';

/// Base class for handling failures
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Represents a failure from the server, optionally includes detailed error message
class ServerFailure extends Failure {
  final ErrorMessageModel? errorMessageModel;

  const ServerFailure({required String message, this.errorMessageModel})
      : super(message: message);

  @override
  List<Object?> get props => [message, errorMessageModel];
}
