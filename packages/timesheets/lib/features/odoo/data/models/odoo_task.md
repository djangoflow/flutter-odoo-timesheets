Available fields for Task on Odoo

```json
{
  active: {
    type: boolean,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    manual: false,
    readonly: false,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: Active
  },
  name: {
    type: char,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    manual: false,
    readonly: false,
    required: true,
    searchable: true,
    sortable: true,
    store: true,
    string: Title,
    translate: false,
    trim: true
  },
  description: {
    type: html,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    manual: false,
    readonly: false,
    required: false,
    sanitize: true,
    sanitize_attributes: true,
    sanitize_style: false,
    sanitize_tags: true,
    searchable: true,
    sortable: true,
    store: true,
    string: Description,
    strip_classes: false,
    strip_style: false,
    translate: false
  },
  sequence: {
    type: integer,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    group_operator: sum,
    help: Givesthesequenceorderwhendisplayingalistoftasks.,
    manual: false,
    readonly: false,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: Sequence
  },
  stage_id: {
    type: many2one,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [
      ('project_ids',
      '=',
      project_id)
    ],
    manual: false,
    readonly: false,
    relation: project.task.type,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: Stage
  },
  tag_ids: {
    type: many2many,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [

    ],
    manual: false,
    readonly: false,
    relation: project.tags,
    required: false,
    searchable: true,
    sortable: false,
    store: true,
    string: Tags
  },
  kanban_state: {
    type: selection,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    manual: false,
    readonly: false,
    required: true,
    searchable: true,
    selection: [
      [
        normal,
        Grey
      ],
      [
        done,
        Green
      ],
      [
        blocked,
        Red
      ]
    ],
    sortable: true,
    store: true,
    string: KanbanState
  },
  kanban_state_label: {
    type: char,
    change_default: false,
    company_dependent: false,
    depends: [
      stage_id,
      kanban_state
    ],
    manual: false,
    readonly: true,
    required: false,
    searchable: false,
    sortable: false,
    store: false,
    string: KanbanStateLabel,
    translate: false,
    trim: true
  },
  create_date: {
    type: datetime,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    manual: false,
    readonly: true,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: CreatedOn
  },
  write_date: {
    type: datetime,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    manual: false,
    readonly: true,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: LastUpdatedOn
  },
  date_end: {
    type: datetime,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    manual: false,
    readonly: false,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: EndingDate
  },
  date_assign: {
    type: datetime,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    manual: false,
    readonly: true,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: AssigningDate
  },
  date_deadline: {
    type: date,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    manual: false,
    readonly: false,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: Deadline
  },
  date_deadline_formatted: {
    type: char,
    change_default: false,
    company_dependent: false,
    depends: [
      date_deadline
    ],
    manual: false,
    readonly: true,
    required: false,
    searchable: false,
    sortable: false,
    store: false,
    string: DateDeadlineFormatted,
    translate: false,
    trim: true
  },
  date_last_stage_update: {
    type: datetime,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    manual: false,
    readonly: true,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: LastStageUpdate
  },
  project_id: {
    type: many2one,
    change_default: true,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [
      ('company_id',
      'in',
      [
        company_id,
        False
      ])
    ],
    manual: false,
    readonly: false,
    relation: project.project,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: Project
  },
  planned_hours: {
    type: float,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    group_operator: sum,
    help: Itisthetimeplannedtoachievethetask.Ifthisdocumenthassub-tasks,
    itmeansthetimeneededtoachievethistasksanditschilds.,
    manual: false,
    readonly: false,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: PlannedHours
  },
  subtask_planned_hours: {
    type: float,
    change_default: false,
    company_dependent: false,
    depends: [
      child_ids.planned_hours
    ],
    group_operator: sum,
    help: Computedusingsumofhoursplannedofallsubtaskscreatedfrommaintask.UsuallythesehoursarelessorequaltothePlannedHours(ofmaintask).,
    manual: false,
    readonly: true,
    required: false,
    searchable: false,
    sortable: false,
    store: false,
    string: Subtasks
  },
  user_id: {
    type: many2one,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [

    ],
    manual: false,
    readonly: false,
    relation: res.users,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: Assignedto
  },
  partner_id: {
    type: many2one,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [
      '|',
      ('company_id',
      '=',
      False),
      ('company_id',
      '=',
      company_id)
    ],
    manual: false,
    readonly: false,
    relation: res.partner,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: Customer
  },
  partner_city: {
    type: char,
    change_default: false,
    company_dependent: false,
    depends: [
      partner_id.city
    ],
    manual: false,
    readonly: false,
    related: [
      partner_id,
      city
    ],
    required: false,
    searchable: true,
    sortable: false,
    store: false,
    string: City,
    translate: false,
    trim: true
  },
  manager_id: {
    type: many2one,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [
      project_id.user_id
    ],
    domain: [

    ],
    manual: false,
    readonly: true,
    related: [
      project_id,
      user_id
    ],
    relation: res.users,
    required: false,
    searchable: true,
    sortable: false,
    store: false,
    string: ProjectManager
  },
  company_id: {
    type: many2one,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [

    ],
    manual: false,
    readonly: false,
    relation: res.company,
    required: true,
    searchable: true,
    sortable: true,
    store: true,
    string: Company
  },
  color: {
    type: integer,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    group_operator: sum,
    manual: false,
    readonly: false,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: ColorIndex
  },
  user_email: {
    type: char,
    change_default: false,
    company_dependent: false,
    depends: [
      user_id.email
    ],
    manual: false,
    readonly: true,
    related: [
      user_id,
      email
    ],
    required: false,
    searchable: true,
    sortable: false,
    store: false,
    string: UserEmail,
    translate: false,
    trim: true
  },
  attachment_ids: {
    type: one2many,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [

    ],
    help: Attachmentthatdon't come from message., manual: false, readonly: true, relation: ir.attachment, required: false, searchable: false, sortable: false, store: false, string: Main Attachments},
    displayed_image_id: {type: many2one, change_default: false, company_dependent: false, context: {}, depends: [], domain: [('res_model', '=', 'project.task'), ('res_id', '=', id), ('mimetype', 'ilike', 'image')], manual: false, readonly: false, relation: ir.attachment, required: false, searchable: true, sortable: true, store: true, string: Cover Image}, legend_blocked: {type: char, change_default: false, company_dependent: false, depends: [stage_id.legend_blocked], help: Override the default value displayed for the blocked state for kanban selection, when the task or issue is in that stage., manual: false, readonly: true, related: [stage_id, legend_blocked], required: false, searchable: true, sortable: false, store: false, string: Kanban Blocked Explanation, translate: true, trim: true}, legend_done: {type: char, change_default: false, company_dependent: false, depends: [stage_id.legend_done], help: Override the default value displayed for the done state for kanban selection, when the task or issue is in that stage., manual: false, readonly: true, related: [stage_id, legend_done], required: false, searchable: true, sortable: false, store: false, string: Kanban Valid Explanation, translate: true, trim: true}, legend_normal: {type: char, change_default: false, company_dependent: false, depends: [stage_id.legend_normal], help: Override the default value displayed for the normal state for kanban selection, when the task or issue is in that stage., manual: false, readonly: true, related: [stage_id, legend_normal], required: false, searchable: true, sortable: false, store: false, string: Kanban Ongoing Explanation, translate: true, trim: true}, parent_id: {type: many2one, change_default: false, company_dependent: false, context: {}, depends: [], domain: [], manual: false, readonly: false, relation: project.task, required: false, searchable: true, sortable: true, store: true, string: Parent Task}, child_ids: {type: one2many, change_default: false, company_dependent: false, context: {active_test: false}, depends: [], domain: [], manual: false, readonly: false, relation: project.task, relation_field: parent_id, required: false, searchable: true, sortable: false, store: true, string: Sub-tasks}, subtask_project_id: {type: many2one, change_default: false, company_dependent: false, context: {}, depends: [project_id.subtask_project_id], domain: [], help: Project in which sub-tasks of the current project will be created. It can be the current project itself., manual: false, readonly: true, related: [project_id, subtask_project_id], relation: project.project, required: false, searchable: true, sortable: false, store: false, string: Sub-task Project}, subtask_count: {type: integer, change_default: false, company_dependent: false, depends: [child_ids], group_operator: sum, manual: false, readonly: true, required: false, searchable: false, sortable: false, store: false, string: Sub-task count}, email_from: {type: char, change_default: false, company_dependent: false, depends: [], help: These people will receive email., manual: false, readonly: false, required: false, searchable: true, sortable: true, store: true, string: Email, translate: false, trim: true}, working_hours_open: {type: float, change_default: false, company_dependent: false, depends: [create_date, date_end, date_assign], group_operator: avg, manual: false, readonly: true, required: false, searchable: true, sortable: true, store: true, string: Working hours to assign}, working_hours_close: {type: float, change_default: false, company_dependent: false, depends: [create_date, date_end, date_assign], group_operator: avg, manual: false, readonly: true, required: false, searchable: true, sortable: true, store: true, string: Working hours to close}, working_days_open: {type: float, change_default: false, company_dependent: false, depends: [create_date, date_end, date_assign], group_operator: avg, manual: false, readonly: true, required: false, searchable: true, sortable: true, store: true, string: Working days to assign}, working_days_close: {type: float, change_default: false, company_dependent: false, depends: [create_date, date_end, date_assign], group_operator: avg, manual: false, readonly: true, required: false, searchable: true, sortable: true, store: true, string: Working days to close}, website_message_ids: {type: one2many, change_default: false, company_dependent: false, context: {}, depends: [], domain: [[model, =, project.task], [message_type, in, [email, comment]]], help: Website communication history, manual: false, readonly: false, relation: mail.message, relation_field: res_id, required: false, searchable: true, sortable: false, store: true, string: Website Messages}, analytic_account_active: {type: boolean, change_default: false, company_dependent: false, depends: [project_id.analytic_account_id.active], help: If the active field is set to False, it will allow you to hide the account without removing it., manual: false, readonly: true, related: [project_id, analytic_account_id, active], required: false, searchable: true, sortable: false, store: false, string: Analytic Account}, allow_timesheets: {type: boolean, change_default: false, company_dependent: false, depends: [project_id.allow_timesheets], help: Timesheets can be logged on this task., manual: false, readonly: true, related: [project_id, allow_timesheets], required: false, searchable: true, sortable: false, store: false, string: Allow timesheets}, remaining_hours: {type: float, change_default: false, company_dependent: false, depends: [effective_hours, subtask_effective_hours, planned_hours], group_operator: sum, help: Total remaining time, can be re-estimated periodically by the assignee of the task., manual: false, readonly: true, required: false, searchable: true, sortable: true, store: true, string: Remaining Hours}, effective_hours: {type: float, change_default: false, company_dependent: false, depends: [timesheet_ids.unit_amount], group_operator: sum, help: Computed using the sum of the task work done., manual: false, readonly: true, required: false, searchable: true, sortable: true, store: true, string: Hours Spent}, total_hours_spent: {type: float, change_default: false, company_dependent: false, depends: [effective_hours, subtask_effective_hours], group_operator: sum, help: Computed as: Time Spent + Sub-tasks Hours., manual: false, readonly: true, required: false, searchable: true, sortable: true, store: true, string: Total Hours}, progress: {type: float, change_default: false, company_dependent: false, depends: [effective_hours, subtask_effective_hours, planned_hours], group_operator: avg, help: Display progress of current task., manual: false, readonly: true, required: false, searchable: true, sortable: true, store: true, string: Progress}, subtask_effective_hours: {type: float, change_default: false, company_dependent: false, depends: [child_ids.effective_hours, child_ids.subtask_effective_hours], group_operator: sum, help: Sum of actually spent hours on the subtask(s), manual: false, readonly: true, required: false, searchable: true, sortable: true, store: true, string: Sub-tasks Hours Spent}, timesheet_ids: {type: one2many, change_default: false, company_dependent: false, context: {}, depends: [], domain: [], manual: false, readonly: false, relation: account.analytic.line, relation_field: task_id, required: false, searchable: true, sortable: false, store: true, string: Timesheets}, type_id: {type: many2one, change_default: false, company_dependent: false, context: {}, depends: [], domain: [('task_ok', '=', True)], manual: false, readonly: false, relation: project.type, required: false, searchable: true, sortable: true, store: true, string: Type}, priority: {type: selection, change_default: false, company_dependent: false, depends: [], manual: false, readonly: false, required: false, searchable: true, selection: [[0, Normal], [1, Important], [2, High], [3, Very High]], sortable: true, store: true, string: Priority}, dependency_task_ids: {type: many2many, change_default: false, company_dependent: false, context: {}, depends: [], domain: [], manual: false, readonly: false, relation: project.task, required: false, searchable: true, sortable: false, store: true, string: Dependencies}, recursive_dependency_task_ids: {type: many2many, change_default: false, company_dependent: false, context: {}, depends: [dependency_task_ids], domain: [], manual: false, readonly: true, relation: project.task, required: false, searchable: false, sortable: false, store: false, string: Recursive Dependencies}, depending_task_ids: {type: many2many, change_default: false, company_dependent: false, context: {}, depends: [dependency_task_ids], domain: [], help: Tasks that are dependent on this task., manual: false, readonly: true, relation: project.task, required: false, searchable: false, sortable: false, store: false, string: Depending Tasks}, recursive_depending_task_ids: {type: many2many, change_default: false, company_dependent: false, context: {}, depends: [dependency_task_ids], domain: [], help: Tasks that are dependent on this task (recursive)., manual: false, readonly: true, relation: project.task, required: false, searchable: false, sortable: false, store: false, string: Recursive Depending Tasks}, pr_uri: {type: char, change_default: false, company_dependent: false, depends: [], manual: false, readonly: false, required: false, searchable: true, sortable: true, store: true, string: PR URI, translate: false, trim: true}, pr_required_states: {type: many2many, change_default: false, company_dependent: false, context: {}, depends: [project_id.pr_required_states], domain: [], manual: false, readonly: true, related: [project_id, pr_required_states], relation: project.task.type, required: false, searchable: true, sortable: false, store: false, string: PR Required States}, date_start: {type: datetime, change_default: false, company_dependent: false, depends: [], manual: false, readonly: false, required: false, searchable: true, sortable: true, store: true, string: Start Date}, milestone_id: {type: many2one, change_default: false, company_dependent: false, context: {}, depends: [], domain: [('project_id', '=', project_id)], manual: false, readonly: false, relation: project.milestone, required: false, searchable: true, sortable: true, store: true, string: Milestone}, use_milestones: {type: boolean, change_default: false, company_dependent: false, depends: [project_id.use_milestones], help: Does this project use milestones?, manual: false, readonly: true, related: [project_id, use_milestones], required: false, searchable: true, sortable: false, store: false, string: Use Milestones}, show_time_control: {type: selection, change_default: false, company_dependent: false, depends: [project_id.allow_timesheets, timesheet_ids.employee_id, timesheet_ids.unit_amount], help: Indicate which time control button to show, if any., manual: false, readonly: true, required: false, searchable: false, selection: [[start, Start], [stop, Stop]], sortable: false, store: false, string: Show Time Control}, sale_line_id: {type: many2one, change_default: false, company_dependent: false, context: {}, depends: [], domain: [('is_service', '=', True), ('order_partner_id', '=', partner_id), ('is_expense', '=', False), ('state', 'in', ['sale', 'done'])], help: Sales order item to which the task is linked. If an employee timesheets on a this task, and if this employee is not in the 'Employee/SalesOrderItemMapping' of the project, the timesheet entry will be linked to this sales order item., manual: false, readonly: false, relation: sale.order.line, required: false, searchable: true, sortable: true, store: true, string: Sales Order Item}, sale_order_id: {type: many2one, change_default: false, company_dependent: false, context: {}, depends: [sale_line_id, project_id, billable_type], domain: [], help: Sales order to which the task is linked., manual: false, readonly: false, relation: sale.order, required: false, searchable: true, sortable: true, store: true, string: Sales Order}, billable_type: {type: selection, change_default: false, company_dependent: false, depends: [project_id.billable_type, sale_line_id], manual: false, readonly: true, required: false, searchable: true, selection: [[task_rate, At Task Rate], [employee_rate, At Employee Rate], [no, No Billable]], sortable: true, store: true, string: Billable Type}, is_project_map_empty: {type: boolean, change_default: false, company_dependent: false, depends: [project_id.sale_line_employee_ids], manual: false, readonly: true, required: false, searchable: false, sortable: false, store: false, string: Is Project map empty}, activity_ids: {type: one2many, change_default: false, company_dependent: false, context: {}, depends: [], domain: [], groups: base.group_user, manual: false, readonly: false, relation: mail.activity, relation_field: res_id, required: false, searchable: true, sortable: false, store: true, string: Activities}, activity_state: {type: selection, change_default: false, company_dependent: false, depends: [activity_ids.state], groups: base.group_user, help: Status based on activities Overdue: Due date is already passed Today: Activity date is today Planned: Future activities., manual: false, readonly: true, required: false, searchable: false, selection: [[overdue, Overdue], [today, Today], [planned, Planned]], sortable: false, store: false, string: Activity State}, activity_user_id: {type: many2one, change_default: false, company_dependent: false, context: {}, depends: [activity_ids.user_id], domain: [], groups: base.group_user, manual: false, readonly: false, related: [activity_ids, user_id], relation: res.users, required: false, searchable: true, sortable: false, store: false, string: Responsible User}, activity_type_id: {type: many2one, change_default: false, company_dependent: false, context: {}, depends: [activity_ids.activity_type_id], domain: ['|', ('res_model_id', '=', False), ('res_model_id', '=', res_model_id)], groups: base.group_user, manual: false, readonly: false, related: [activity_ids, activity_type_id], relation: mail.activity.type, required: false, searchable: true, sortable: false, store: false, string: Next Activity Type}, activity_date_deadline: {type: date, change_default: false, company_dependent: false, depends: [activity_ids.date_deadline], groups: base.group_user, manual: false, readonly: true, required: false, searchable: true, sortable: false, store: false, string: Next Activity Deadline}, activity_summary: {type: char, change_default: false, company_dependent: false, depends: [activity_ids.summary], groups: base.group_user, manual: false, readonly: false, related: [activity_ids, summary], required: false, searchable: true, sortable: false, store: false, string: Next Activity Summary, translate: false, trim: true}, activity_exception_decoration: {type: selection, change_default: false, company_dependent: false, depends: [activity_ids.activity_type_id.decoration_type, activity_ids.activity_type_id.icon], help: Type of the exception activity on record., manual: false, readonly: true, required: false, searchable: true, selection: [[warning, Alert], [danger, Error]], sortable: false, store: false, string: Activity Exception Decoration}, activity_exception_icon: {type: char, change_default: false, company_dependent: false, depends: [activity_ids.activity_type_id.decoration_type, activity_ids.activity_type_id.icon], help: Icon to indicate an exception activity., manual: false, readonly: true, required: false, searchable: false, sortable: false, store: false, string: Icon, translate: false, trim: true}, email_cc: {type: char, change_default: false, company_dependent: false, depends: [], help: List of cc from incoming emails., manual: false, readonly: false, required: false, searchable: true, sortable: true, store: true, string: Email cc, translate: false, trim: true}, message_is_follower: {type: boolean, change_default: false, company_dependent: false, depends: [message_follower_ids], manual: false, readonly: true, required: false, searchable: true, sortable: false, store: false, string: Is Follower}, message_follower_ids: {type: one2many, change_default: false, company_dependent: false, context: {}, depends: [], domain: [], manual: false, readonly: false, relation: mail.followers, relation_field: res_id, required: false, searchable: true, sortable: false, store: true, string: Followers}, message_partner_ids: {type: many2many, change_default: false, company_dependent: false, context: {}, depends: [message_follower_ids], domain: [], manual: false, readonly: true, relation: res.partner, required: false, searchable: true, sortable: false, store: false, string: Followers (Partners)}, message_channel_ids: {type: many2many, change_default: false, company_dependent: false, context: {}, depends: [message_follower_ids], domain: [], manual: false, readonly: true, relation: mail.channel, required: false, searchable: true, sortable: false, store: false, string: Followers (Channels)}, message_ids: {type: one2many, change_default: false, company_dependent: false, context: {}, depends: [], domain: [[message_type, !=, user_notification]], manual: false, readonly: false, relation: mail.message, relation_field: res_id, required: false, searchable: true, sortable: false, store: true, string: Messages}, message_unread: {type: boolean, change_default: false, company_dependent: false, depends: [], help: If checked, new messages require your attention., manual: false, readonly: true, required: false, searchable: false, sortable: false, store: false, string: Unread Messages}, message_unread_counter: {type: integer, change_default: false, company_dependent: false, depends: [], group_operator: sum, help: Number of unread messages, manual: false, readonly: true, required: false, searchable: false, sortable: false, store: false, string: Unread Messages Counter}, message_needaction: {type: boolean, change_default: false, company_dependent: false, depends: [], help: If checked, new messages require your attention., manual: false, readonly: true, required: false, searchable: true, sortable: false, store: false, string: Action Needed}, message_needaction_counter: {type: integer, change_default: false, company_dependent: false, depends: [], group_operator: sum, help: Number of messages which requires an action, manual: false, readonly: true, required: false, searchable: false, sortable: false, store: false, string: Number of Actions}, message_has_error: {type: boolean, change_default: false, company_dependent: false, depends: [], help: If checked, some messages have a delivery error., manual: false, readonly: true, required: false, searchable: true, sortable: false, store: false, string: Message Delivery error}, message_has_error_counter: {type: integer, change_default: false, company_dependent: false, depends: [], group_operator: sum, help: Number of messages with delivery error, manual: false, readonly: true, required: false, searchable: false, sortable: false, store: false, string: Number of errors}, message_attachment_count: {type: integer, change_default: false, company_dependent: false, depends: [], group_operator: sum, groups: base.group_user, manual: false, readonly: true, required: false, searchable: false, sortable: false, store: false, string: Attachment Count}, message_main_attachment_id: {type: many2one, change_default: false, company_dependent: false, context: {}, depends: [], domain: [], manual: false, readonly: false, relation: ir.attachment, required: false, searchable: true, sortable: true, store: true, string: Main Attachment}, failed_message_ids: {type: one2many, change_default: false, company_dependent: false, context: {}, depends: [], domain: [[model, =, project.task], [mail_tracking_needs_action, =, true], [mail_tracking_ids.state, in, [bounced, error, soft-bounced, spam, rejected]]], manual: false, readonly: false, relation: mail.message, relation_field: res_id, required: false, searchable: true, sortable: false, store: true, string: Failed Messages}, message_has_sms_error: {type: boolean, change_default: false, company_dependent: false, depends: [], help: If checked, some messages have a delivery error., manual: false, readonly: true, required: false, searchable: true, sortable: false, store: false, string: SMS Delivery error}, rating_ids: {type: one2many, change_default: false, company_dependent: false, context: {}, depends: [], domain: [[res_model, =, project.task]], manual: false, readonly: false, relation: rating.rating, relation_field: res_id, required: false, searchable: true, sortable: false, store: true, string: Rating}, rating_last_value: {type: float, change_default: false, company_dependent: false, depends: [rating_ids.rating, rating_ids.consumed], group_operator: sum, manual: false, readonly: true, required: false, searchable: true, sortable: true, store: true, string: Rating Last Value}, rating_last_feedback: {type: text, change_default: false, company_dependent: false, depends: [rating_ids.feedback], help: Reason of the rating, manual: false, readonly: true, related: [rating_ids, feedback], required: false, searchable: true, sortable: false, store: false, string: Rating Last Feedback, translate: false}, rating_last_image: {type: binary, attachment: false, change_default: false, company_dependent: false, depends: [rating_ids.rating_image], manual: false, readonly: true, related: [rating_ids, rating_image], required: false, searchable: false, sortable: false, store: false, string: Rating Last Image}, rating_count: {type: integer, change_default: false, company_dependent: false, depends: [rating_ids], group_operator: sum, manual: false, readonly: true, required: false, searchable: false, sortable: false, store: false, string: Rating count}, rating_avg: {type: float, change_default: false, company_dependent: false, depends: [rating_ids], group_operator: sum, manual: false, readonly: true, required: false, searchable: false, sortable: false, store: false, string: Rating Average}, access_url: {type: char, change_default: false, company_dependent: false, depends: [], help: Customer Portal URL, manual: false, readonly: true, required: false, searchable: false, sortable: false, store: false, string: Portal Access URL, translate: false, trim: true}, access_token: {type: char, change_default: false, company_dependent: false, depends: [], manual: false, readonly: false, required: false, searchable: true, sortable: true, store: true, string: Security Token, translate: false, trim: true}, access_warning: {type: text, change_default: false, company_dependent: false, depends: [], manual: false, readonly: true, required: false, searchable: false, sortable: false, store: false, string: Access warning, translate: false}, assigned_attachment_ids: {type: one2many, change_default: false, company_dependent: false, context: {}, depends: [], domain: [[res_model, =, project.task]], manual: false, readonly: false, relation: ir.attachment, relation_field: res_id, required: false, searchable: true, sortable: false, store: true, string: Assigned Attachments}, id: {type: integer, change_default: false, company_dependent: false, depends: [], manual: false, readonly: true, required: false, searchable: true, sortable: true, store: true, string: ID}, display_name: {type: char, change_default: false, company_dependent: false, depends: [name], manual: false, readonly: true, required: false, searchable: false, sortable: false, store: false, string: Display Name, translate: false, trim: true}, create_uid: {type: many2one, change_default: false, company_dependent: false, context: {}, depends: [], domain: [], manual: false, readonly: true, relation: res.users, required: false, searchable: true, sortable: true, store: true, string: Created by}, write_uid: {type: many2one, change_default: false, company_dependent: false, context: {}, depends: [], domain: [], manual: false, readonly: true, relation: res.users, required: false, searchable: true, sortable: true, store: true, string: Last Updated by}, __last_update: {type: datetime, change_default: false, company_dependent: false, depends: [create_date, write_date], manual: false, readonly: true, required: false, searchable: false, sortable: false, store: false, string: Last Modified on}}
```
