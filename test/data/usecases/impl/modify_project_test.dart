import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/data/repositories/projects_repository.dart';
import 'package:costy/data/usecases/impl/modify_project.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockProjectsRepository extends Mock implements ProjectsRepository {}

void main() {
  ModifyProject modifyProject;
  MockProjectsRepository mockProjectsRepository;

  setUp(() {
    mockProjectsRepository = MockProjectsRepository();
    modifyProject = ModifyProject(projectsRepository: mockProjectsRepository);
  });

  final tProject = Project(
      id: 1, name: 'Sample project.', defaultCurrency: Currency(name: 'USD'));

  test('should modify project using a repository', () async {
    //arrange
    when(mockProjectsRepository.modifyProject(any))
        .thenAnswer((_) async => Right(tProject.id));
    //act
    final result = await modifyProject.call(Params(project: tProject));
    //assert
    expect(result, Right(tProject.id));
    verify(mockProjectsRepository.modifyProject(tProject));
    verifyNoMoreInteractions(mockProjectsRepository);
  });
}
