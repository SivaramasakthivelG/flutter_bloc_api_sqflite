
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_flutter/data/repository/local_db_helper.dart';
import 'package:learn_flutter/domain/usecases/get_users.dart';
import 'package:learn_flutter/presentation/bloc/user_event.dart';
import 'package:learn_flutter/presentation/bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState>{
    final GetUsers getUsers;


    UserBloc(this.getUsers) : super(UserInitial()){
        on<FetchUsersEvent>(_onFetchUsers);
        on<ToggleSaveUserEvent>(_onToggleSaveUser);
    }

    /*UserBloc(this.getUsers) : super(UserInitial()){
      on<FetchUsersEvent>((event, emit) async{
        emit(UserLoading());
        try{
          final users = await getUsers();
          emit(UserLoaded(users));
        }catch (e) {
          emit(UserError("Failed to fetch Users"));
        }
      });
    }*/


  FutureOr<void> _onFetchUsers(FetchUsersEvent event, Emitter<UserState> emit) async{
      emit(UserLoading());
      try{
        final users = await getUsers();
        final savedUsers = await LocalDBHelper.getAllUsers();
        final saveIds = savedUsers.map((u) => u.id).toSet();
        emit(UserLoaded(users,saveIds));
      }catch (e) {
        emit(UserError("Failed to fetch Users"));
      }
  }

  FutureOr<void> _onToggleSaveUser(ToggleSaveUserEvent event, Emitter<UserState> emit) async{
      if(state is UserLoaded){
        final currentState = state as UserLoaded;
        final isSaved = currentState.savedUserIds.contains(event.user.id);

        if(isSaved){
          await LocalDBHelper.deleteUser(event.user.id);
        }else{
          await LocalDBHelper.insertUser(event.user);
        }

        final updateSavedIds = Set<int>.from(currentState.savedUserIds);
        isSaved ? updateSavedIds.remove(event.user.id) : updateSavedIds.add(event.user.id);

        emit(UserLoaded(currentState.users, updateSavedIds));
      }


  }

}