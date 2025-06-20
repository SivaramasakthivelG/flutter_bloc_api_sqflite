
import '../../data/repository/IUserRepository.dart';
import '../entities/user.dart';

class GetUsers {
  final IUserRepository repository;

  GetUsers(this.repository);

  Future<List<User>> call() async {
    final userModels = await repository.fetchUsers();
      return userModels.map((model) => model.toEntity()).toList();
  }
}
