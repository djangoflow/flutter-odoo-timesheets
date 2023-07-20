import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';

@RoutePage()
class ProjectDetailsPage extends StatelessWidget {
  const ProjectDetailsPage({super.key, @pathParam required this.projectId});
  final int projectId;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
