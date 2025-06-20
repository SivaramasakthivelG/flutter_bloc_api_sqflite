
import 'package:equatable/equatable.dart';
import 'package:learn_flutter/domain/entities/user.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class FetchUsersEvent extends UserEvent{}

class ToggleSaveUserEvent extends UserEvent {
  final User user;
  ToggleSaveUserEvent(this.user);
}