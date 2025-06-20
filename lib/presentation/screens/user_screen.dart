import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_flutter/data/mixins/toast_mixin.dart';
import 'package:learn_flutter/presentation/bloc/user_bloc.dart';
import 'package:learn_flutter/presentation/bloc/user_event.dart';
import 'package:learn_flutter/presentation/screens/saved_user_screen.dart';

import '../bloc/user_state.dart';

class UserScreen extends StatefulWidget {
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> with ToastMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User List"),
        actions: [
          IconButton(onPressed:() {
            Navigator.push(context, MaterialPageRoute(builder: (_) => SavedUserScreen()),
            );
          },
            icon: Icon(Icons.menu)
          )
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (BuildContext context, UserState state) {
          if (state is UserInitial) {
            context.read<UserBloc>().add(FetchUsersEvent());
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (_, index) {
                final user = state.users[index];
                final isSaved = state.savedUserIds.contains(user.id);
                return ListTile(
                  trailing: IconButton(
                    icon: Icon(isSaved ? Icons.bookmark_add : Icons.bookmark_border),
                    onPressed: () async {
                      context.read<UserBloc>().add(ToggleSaveUserEvent(user));
                      showToast("State Updated");
                    },
                  ),
                  leading: CircleAvatar(child: Text(user.id.toString())),
                  title: Row(
                    children: [
                      Flexible(
                        flex: 4,
                        child: Text("User: ", overflow: TextOverflow.ellipsis),
                      ),
                      Flexible(
                        flex: 20,
                        child: Text(
                          user.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Text("Mail: "),
                      Expanded(child: Text(user.email)),
                    ],
                  ),
                );
              },
            );
          } else if (state is UserError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
