import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/blocs/project_paginated_filter.dart';
import 'package:timesheets/features/in_memory_backend/data/repositories/in_memory_project_repository.dart';
import 'package:timesheets/features/project/data/models/project.dart';

class ProjectRepository
    implements CrudRepository<Project, ProjectPaginatedFilter> {
  // This should be something swappable with other implementations for local, odoo etc.
  // Maybe a abstract backend class that extens from CrudRepository and some converter to
  // convert from the backend model to the local Project model
  // And those backends and their part of the code can be separate dart packages so we can isolate them.
  final InMemoryProjectRepository _repository;

  ProjectRepository({required InMemoryProjectRepository repository})
      : _repository = repository;
  @override
  Future<int> createItem(Project item) => _repository.createItem(item);

  @override
  Future<int> deleteItem(int id) => _repository.deleteItem(id);

  @override
  Future<List<Project>> getAllItems() => _repository.getAllItems();

  @override
  Future<Project?> getItemById(int id) => _repository.getItemById(id);

  @override
  Future<List<Project>> getPaginatedItems([ProjectPaginatedFilter? filter]) =>
      _repository.getPaginatedItems(filter);

  @override
  Future<void> updateItem(Project item) => _repository.updateItem(item);
}
