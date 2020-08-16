import 'package:equatable/equatable.dart';

import '../../data/models/project.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();
}

class ProjectEmpty extends ProjectState {
  @override
  List<Object> get props => [];
}

class ProjectLoading extends ProjectState {
  @override
  List<Object> get props => [];
}

class ProjectLoaded extends ProjectState {
  final List<Project> projects;

  const ProjectLoaded(this.projects);

  @override
  List<Object> get props => [projects];
}

class ProjectAdded extends ProjectState {
  final int projectId;

  const ProjectAdded(this.projectId);

  @override
  List<Object> get props => [projectId];
}

class ProjectModified extends ProjectState {
  final int projectId;

  const ProjectModified(this.projectId);

  @override
  List<Object> get props => [projectId];
}

class ProjectDeleted extends ProjectState {
  final int projectId;

  const ProjectDeleted(this.projectId);

  @override
  List<Object> get props => [projectId];
}

class ProjectError extends ProjectState {
  final String errorMessage;

  const ProjectError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
