import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/task/task.dart';

import '../../features/sync/data/database/database.dart';

extension ProjectConversion on ProjectProject {
  ProjectModel toDomainModel() => ProjectModel(
        id: id,
        createDate: createDate,
        writeDate: writeDate,
        name: name,
        isMarkedAsDeleted: isMarkedAsDeleted,
        active: active,
        isFavorite: isFavorite,
        taskCount: taskCount,
        color: color,
      );
}

extension TaskConversion on ProjectTask {
  TaskModel toDomainModel() => TaskModel(
        id: id,
        createDate: createDate,
        writeDate: writeDate,
        name: name,
        active: active,
        color: color,
        dateDeadline: dateDeadline,
        dateEnd: dateEnd,
        description: description,
        priority: priority,
        projectId: projectId,
        isMarkedAsDeleted: isMarkedAsDeleted,
      );
}

extension AnalyticLineConversion on AnalyticLine {
  TimesheetModel toDomainModel() => TimesheetModel(
        id: id,
        date: date,
        name: name,
        projectId: projectId,
        taskId: taskId,
        createDate: createDate,
        writeDate: writeDate,
        isMarkedAsDeleted: isMarkedAsDeleted,
        currentStatus: currentStatus,
        lastTicked: lastTicked,
        unitAmount: unitAmount,
        isFavorite: isFavorite,
        dateTime: startTime,
        dateTimeEnd: endTime,
        showTimeControl: showTimeControl,
      );
}
