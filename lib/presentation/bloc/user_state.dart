
import 'dart:ffi';

import 'package:equatable/equatable.dart';
import 'package:learn_flutter/domain/entities/user.dart';

abstract class UserState extends Equatable{
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState{}

class UserLoading extends UserState{}

class UserLoaded extends UserState{
    final List<User> users;
    final Set<int> savedUserIds;

    const UserLoaded(this.users,this.savedUserIds);

    @override
    List<Object> get props => [users,savedUserIds];
}

class UserError extends UserState{
  final String message;

  const UserError(this.message);

  @override
  List<Object> get props => [message];
}