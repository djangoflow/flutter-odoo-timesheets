
// TODO need to implement this
// class SyncCubit extends Cubit<SyncState> {
//   final ProjectRepository projectRepository;
//   final TaskRepository taskRepository;
//   final TimesheetRepository timesheetRepository;      
//   final OdooTaskRepository odooTaskRepository;
//   final OdooTimesheetRepository odooTimesheetRepository;
//   final OdooProjectRepository odooProjectRepository;

//   SyncCubit({
//     required this.projectRepository,
//     required this.taskRepository,
//     required this.timesheetRepository,
//     required this.odooTaskRepository,
//     required this.odooTimesheetRepository,
//     required this.odooProjectRepository,
//   }) : super(SyncState(isSyncing: false));

//   // Handle the SyncData event
//   Future<void> syncData() async {
//     try {
//       emit(SyncState(isSyncing: true));

//       // Fetch projects from Odoo and insert/update in the local database
//       List<Project> projects = await odooProjectsRepository.getAllProjects();
//       await projectRepository.syncProjects(projects);

//       // Fetch tasks from Odoo and insert/update in the local database
//       List<Task> tasks = await odooTaskRepository.getAllTasks();
//       await taskRepository.syncTasks(tasks);

//       // Fetch timesheets from Odoo and insert/update in the local database
//       List<Timesheet> timesheets = await odooTimesheetRepository.getAllTimesheets();
//       await timesheetRepository.syncTimesheets(timesheets);

//       emit(SyncState(isSyncing: false));
//     } catch (error) {
//       emit(SyncState(isSyncing: false, error: 'Sync failed: $error'));
//     }
//   }
// }