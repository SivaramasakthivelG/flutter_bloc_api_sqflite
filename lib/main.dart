import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'data/repository/IUserRepository.dart';
import 'domain/usecases/get_users.dart';
import 'presentation/bloc/user_bloc.dart';
import 'presentation/screens/user_screen.dart';

final getIt = GetIt.instance;

void setupDependencies() {

  getIt.registerLazySingleton<IUserRepository>(() => UserRepositoryImpl());

  getIt.registerLazySingleton(() => GetUsers(getIt<IUserRepository>()));

  getIt.registerFactory(() => UserBloc(getIt<GetUsers>()));
}

void main() {
  setupDependencies();
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User List App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => getIt<UserBloc>(),
        child: UserScreen(),
      ),
    );
  }
}
