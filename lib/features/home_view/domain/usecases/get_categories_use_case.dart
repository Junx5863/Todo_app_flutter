import 'package:dartz/dartz.dart';
import 'package:dash_todo_app/core/base/base_usecase.dart';
import 'package:dash_todo_app/core/errors/failure.dart';
import 'package:dash_todo_app/features/home_view/data/model/categories_model.dart';
import 'package:dash_todo_app/features/home_view/domain/repositories/task_manager_repository.dart';

class GetCategoriesUseCase extends BaseUseCase<List<CategoryModel>, NoParams> {
  final TaskManagerRepository taskManagerRepository;
  GetCategoriesUseCase({required this.taskManagerRepository});
  @override
  Future<Either<Failure, List<CategoryModel>>> call(NoParams params) {
    return taskManagerRepository.getCategories();
  }
}
