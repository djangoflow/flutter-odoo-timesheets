Available fields for Project model on Odoo

```Json
{
  name: {
    type: char,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    manual: false,
    readonly: true,
    required: true,
    searchable: true,
    sortable: true,
    store: true,
    string: Name,
    translate: false,
    trim: true,
    states: {

    }
  },
  active: {
    type: boolean,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    help: IftheactivefieldissettoFalse,
    itwillallowyoutohidetheprojectwithoutremovingit.,
    manual: false,
    readonly: true,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: Active,
    states: {

    }
  },
  sequence: {
    type: integer,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    group_operator: sum,
    help: GivesthesequenceorderwhendisplayingalistofProjects.,
    manual: false,
    readonly: true,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: Sequence,
    states: {

    }
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
    readonly: true,
    relation: res.partner,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: Customer,
    states: {

    }
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
    readonly: true,
    relation: res.company,
    required: true,
    searchable: true,
    sortable: true,
    store: true,
    string: Company,
    states: {

    }
  },
  currency_id: {
    type: many2one,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [
      company_id.currency_id
    ],
    domain: [

    ],
    manual: false,
    readonly: true,
    related: [
      company_id,
      currency_id
    ],
    relation: res.currency,
    required: false,
    searchable: true,
    sortable: false,
    store: false,
    string: Currency,
    states: {

    }
  },
  analytic_account_id: {
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
    help: Analyticaccounttowhichthisprojectislinkedforfinancialmanagement.Useananalyticaccounttorecordcostandrevenueonyourproject.,
    manual: false,
    readonly: true,
    relation: account.analytic.account,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: AnalyticAccount,
    states: {

    }
  },
  favorite_user_ids: {
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
    readonly: true,
    relation: res.users,
    required: false,
    searchable: true,
    sortable: false,
    store: true,
    string: Members,
    states: {

    }
  },
  is_favorite: {
    type: boolean,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    help: Whetherthisprojectshouldbedisplayedonyourdashboard.,
    manual: false,
    readonly: true,
    required: false,
    searchable: false,
    sortable: false,
    store: false,
    string: ShowProjectondashboard,
    states: {

    }
  },
  label_tasks: {
    type: char,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    help: Labelusedforthetasksoftheproject.,
    manual: false,
    readonly: true,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: UseTasksas,
    translate: true,
    trim: true,
    states: {

    }
  },
  tasks: {
    type: one2many,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [

    ],
    manual: false,
    readonly: true,
    relation: project.task,
    relation_field: project_id,
    required: false,
    searchable: true,
    sortable: false,
    store: true,
    string: TaskActivities,
    states: {

    }
  },
  resource_calendar_id: {
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
    help: Timetableworkinghourstoadjusttheganttdiagramreport,
    manual: false,
    readonly: true,
    relation: resource.calendar,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: WorkingTime,
    states: {

    }
  },
  type_ids: {
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
    readonly: true,
    relation: project.task.type,
    required: false,
    searchable: true,
    sortable: false,
    store: true,
    string: TasksStages,
    states: {

    }
  },
  task_count: {
    type: integer,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    group_operator: sum,
    manual: false,
    readonly: true,
    required: false,
    searchable: false,
    sortable: false,
    store: false,
    string: TaskCount,
    states: {

    }
  },
  task_ids: {
    type: one2many,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [
      task_ids.stage_id.fold,
      task_ids.stage_id
    ],
    domain: [
      |,
      [
        stage_id.fold,
        =,
        false
      ],
      [
        stage_id,
        =,
        false
      ]
    ],
    manual: false,
    readonly: true,
    relation: project.task,
    relation_field: project_id,
    required: false,
    searchable: true,
    sortable: false,
    store: true,
    string: Tasks,
    states: {

    }
  },
  color: {
    type: integer,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    group_operator: sum,
    manual: false,
    readonly: true,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: ColorIndex,
    states: {

    }
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
    readonly: true,
    relation: res.users,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: ProjectManager,
    states: {

    }
  },
  alias_id: {
    type: many2one,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [

    ],
    help: Internalemailassociatedwiththisproject.IncomingemailsareautomaticallysynchronizedwithTasks(oroptionallyIssuesiftheIssueTrackermoduleisinstalled).,
    manual: false,
    readonly: true,
    relation: mail.alias,
    required: true,
    searchable: true,
    sortable: true,
    store: true,
    string: Alias,
    states: {

    }
  },
  privacy_visibility: {
    type: selection,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    help: Peopletowhomthisprojectanditstaskswillbevisible.-Invitedinternalusers: whenfollowingaproject,
    internaluserswillgetaccesstoallofitstaskswithoutdistinction.Otherwise,
    theywillonlygetaccesstothespecifictaskstheyarefollowing.Auserwiththeproject>administratoraccessrightlevelcanstillaccessthisprojectanditstasks,
    eveniftheyarenotexplicitlypartofthefollowers.-Allinternalusers: allinternaluserscanaccesstheprojectandallofitstaskswithoutdistinction.-Invitedportalusersandallinternalusers: allinternaluserscanaccesstheprojectandallofitstaskswithoutdistinction.Whenfollowingaproject,
    portaluserswillgetaccesstoallofitstaskswithoutdistinction.Otherwise,
    theywillonlygetaccesstothespecifictaskstheyarefollowing.Inanycase,
    aninternaluserwithnoprojectaccessrightscanstillaccessatask,
    providedthattheyaregiventhecorrespondingURL(andthattheyarepartofthefollowersiftheprojectisprivate).,
    manual: false,
    readonly: true,
    required: true,
    searchable: true,
    selection: [
      [
        followers,
        Invitedinternalusers
      ],
      [
        employees,
        Allinternalusers
      ],
      [
        portal,
        Invitedportalusersandallinternalusers
      ]
    ],
    sortable: true,
    store: true,
    string: Visibility,
    states: {

    }
  },
  doc_count: {
    type: integer,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    group_operator: sum,
    manual: false,
    readonly: true,
    required: false,
    searchable: false,
    sortable: false,
    store: false,
    string: Numberofdocumentsattached,
    states: {

    }
  },
  date_start: {
    type: date,
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
    string: StartDate,
    states: {

    }
  },
  date: {
    type: date,
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
    string: ExpirationDate,
    states: {

    }
  },
  subtask_project_id: {
    type: many2one,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [

    ],
    help: Projectinwhichsub-tasksofthecurrentprojectwillbecreated.Itcanbethecurrentprojectitself.,
    manual: false,
    readonly: true,
    relation: project.project,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: Sub-taskProject,
    states: {

    }
  },
  rating_request_deadline: {
    type: datetime,
    change_default: false,
    company_dependent: false,
    depends: [
      rating_status,
      rating_status_period
    ],
    manual: false,
    readonly: true,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: RatingRequestDeadline,
    states: {

    }
  },
  rating_status: {
    type: selection,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    help: Howtogetcustomerfeedback?-Ratingwhenchangingstage: anemailwillbesentwhenataskispulledinanotherstage.-PeriodicalRating: emailwillbesentperiodically.Don't forget to set up the mail templates on the stages for which you want to get the customer'sfeedbacks.,
    manual: false,
    readonly: true,
    required: true,
    searchable: true,
    selection: [
      [
        stage,
        Ratingwhenchangingstage
      ],
      [
        periodic,
        PeriodicalRating
      ],
      [
        no,
        Norating
      ]
    ],
    sortable: true,
    store: true,
    string: Customer(s)Ratings,
    states: {

    }
  },
  rating_status_period: {
    type: selection,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    manual: false,
    readonly: true,
    required: false,
    searchable: true,
    selection: [
      [
        daily,
        Daily
      ],
      [
        weekly,
        Weekly
      ],
      [
        bimonthly,
        TwiceaMonth
      ],
      [
        monthly,
        OnceaMonth
      ],
      [
        quarterly,
        Quarterly
      ],
      [
        yearly,
        Yearly
      ]
    ],
    sortable: true,
    store: true,
    string: RatingFrequency,
    states: {

    }
  },
  portal_show_rating: {
    type: boolean,
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
    string: Ratingvisiblepublicly,
    states: {

    }
  },
  allow_timesheets: {
    type: boolean,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    help: Enabletimesheetingontheproject.,
    manual: false,
    readonly: true,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: Timesheets,
    states: {

    }
  },
  type_id: {
    type: many2one,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [
      ('project_ok',
      '=',
      True)
    ],
    manual: false,
    readonly: true,
    relation: project.type,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: Type,
    states: {

    }
  },
  description: {
    type: html,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    manual: false,
    readonly: true,
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
    translate: false,
    states: {

    }
  },
  parent_id: {
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
    readonly: true,
    relation: project.project,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: ParentProject,
    states: {

    }
  },
  child_ids: {
    type: one2many,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [

    ],
    manual: false,
    readonly: true,
    relation: project.project,
    relation_field: parent_id,
    required: false,
    searchable: true,
    sortable: false,
    store: true,
    string: Sub-projects,
    states: {

    }
  },
  parent_path: {
    type: char,
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
    string: ParentPath,
    translate: false,
    trim: true,
    states: {

    }
  },
  child_ids_count: {
    type: integer,
    change_default: false,
    company_dependent: false,
    depends: [
      child_ids
    ],
    group_operator: sum,
    manual: false,
    readonly: true,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: ChildIdsCount,
    states: {

    }
  },
  pr_required_states: {
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
    readonly: true,
    relation: project.task.type,
    required: false,
    searchable: true,
    sortable: false,
    store: true,
    string: PRRequiredStates,
    states: {

    }
  },
  is_template: {
    type: boolean,
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
    string: IsTemplate,
    states: {

    }
  },
  is_timesheet_task_required: {
    type: boolean,
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
    string: RequireTasksonTimesheets,
    states: {

    }
  },
  milestone_ids: {
    type: one2many,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [

    ],
    manual: false,
    readonly: true,
    relation: project.milestone,
    relation_field: project_id,
    required: false,
    searchable: true,
    sortable: false,
    store: true,
    string: Milestones,
    states: {

    }
  },
  use_milestones: {
    type: boolean,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    help: Doesthisprojectusemilestones?,
    manual: false,
    readonly: true,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: UseMilestones,
    states: {

    }
  },
  show_time_control: {
    type: selection,
    change_default: false,
    company_dependent: false,
    depends: [
      allow_timesheets
    ],
    help: Indicatewhichtimecontrolbuttontoshow,
    ifany.,
    manual: false,
    readonly: true,
    required: false,
    searchable: false,
    selection: [
      [
        start,
        Start
      ],
      [
        stop,
        Stop
      ]
    ],
    sortable: false,
    store: false,
    string: ShowTimeControl,
    states: {

    }
  },
  sale_line_id: {
    type: many2one,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [
      ('is_expense',
      '=',
      False),
      ('order_id',
      '=',
      sale_order_id),
      ('state',
      'in',
      [
        'sale',
        'done'
      ]),
      '|',
      ('company_id',
      '=',
      False),
      ('company_id',
      '=',
      company_id)
    ],
    help: Salesorderitemtowhichtheprojectislinked.Ifanemployeetimesheetsonataskthatdoesnothaveasaleorderitemdefines,
    andifthisemployeeisnotinthe'Employee/Sales Order Item Mapping'oftheproject,
    thetimesheetentrywillbelinkedtothesalesorderitemdefinedontheproject.,
    manual: false,
    readonly: true,
    relation: sale.order.line,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: SalesOrderItem,
    states: {

    }
  },
  sale_order_id: {
    type: many2one,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [
      ('partner_id',
      '=',
      partner_id)
    ],
    help: Salesordertowhichtheprojectislinked.,
    manual: false,
    readonly: true,
    relation: sale.order,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: SalesOrder,
    states: {

    }
  },
  billable_type: {
    type: selection,
    change_default: false,
    company_dependent: false,
    depends: [
      sale_order_id,
      sale_line_id,
      sale_line_employee_ids
    ],
    help: Atwhichratetimesheetswillbebilled: -Attaskrate: eachtimespendonataskisbilledattaskrate.-Atemployeerate: eachemployeelogtimebilledathisrate.-NoBillable: tracktimewithoutinvoicingit,
    manual: false,
    readonly: true,
    required: false,
    searchable: true,
    selection: [
      [
        task_rate,
        AtTaskRate
      ],
      [
        employee_rate,
        AtEmployeeRate
      ],
      [
        no,
        NoBillable
      ]
    ],
    sortable: true,
    store: true,
    string: BillableType,
    states: {

    }
  },
  sale_line_employee_ids: {
    type: one2many,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [

    ],
    help: Employee/SaleOrderItemMapping: Definestowhichsalesorderitemanemployee's timesheet entry will be linked.By extension, it defines the rate at which an employee'stimeontheprojectisbilled.,
    manual: false,
    readonly: true,
    relation: project.sale.line.employee.map,
    relation_field: project_id,
    required: false,
    searchable: true,
    sortable: false,
    store: true,
    string: Saleline/Employeemap,
    states: {

    }
  },
  message_is_follower: {
    type: boolean,
    change_default: false,
    company_dependent: false,
    depends: [
      message_follower_ids
    ],
    manual: false,
    readonly: true,
    required: false,
    searchable: true,
    sortable: false,
    store: false,
    string: IsFollower,
    states: {

    }
  },
  message_follower_ids: {
    type: one2many,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [

    ],
    manual: false,
    readonly: true,
    relation: mail.followers,
    relation_field: res_id,
    required: false,
    searchable: true,
    sortable: false,
    store: true,
    string: Followers,
    states: {

    }
  },
  message_partner_ids: {
    type: many2many,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [
      message_follower_ids
    ],
    domain: [

    ],
    manual: false,
    readonly: true,
    relation: res.partner,
    required: false,
    searchable: true,
    sortable: false,
    store: false,
    string: Followers(Partners),
    states: {

    }
  },
  message_channel_ids: {
    type: many2many,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [
      message_follower_ids
    ],
    domain: [

    ],
    manual: false,
    readonly: true,
    relation: mail.channel,
    required: false,
    searchable: true,
    sortable: false,
    store: false,
    string: Followers(Channels),
    states: {

    }
  },
  message_ids: {
    type: one2many,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [
      [
        message_type,
        !=,
        user_notification
      ]
    ],
    manual: false,
    readonly: true,
    relation: mail.message,
    relation_field: res_id,
    required: false,
    searchable: true,
    sortable: false,
    store: true,
    string: Messages,
    states: {

    }
  },
  message_unread: {
    type: boolean,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    help: Ifchecked,
    newmessagesrequireyourattention.,
    manual: false,
    readonly: true,
    required: false,
    searchable: false,
    sortable: false,
    store: false,
    string: UnreadMessages,
    states: {

    }
  },
  message_unread_counter: {
    type: integer,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    group_operator: sum,
    help: Numberofunreadmessages,
    manual: false,
    readonly: true,
    required: false,
    searchable: false,
    sortable: false,
    store: false,
    string: UnreadMessagesCounter,
    states: {

    }
  },
  message_needaction: {
    type: boolean,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    help: Ifchecked,
    newmessagesrequireyourattention.,
    manual: false,
    readonly: true,
    required: false,
    searchable: true,
    sortable: false,
    store: false,
    string: ActionNeeded,
    states: {

    }
  },
  message_needaction_counter: {
    type: integer,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    group_operator: sum,
    help: Numberofmessageswhichrequiresanaction,
    manual: false,
    readonly: true,
    required: false,
    searchable: false,
    sortable: false,
    store: false,
    string: NumberofActions,
    states: {

    }
  },
  message_has_error: {
    type: boolean,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    help: Ifchecked,
    somemessageshaveadeliveryerror.,
    manual: false,
    readonly: true,
    required: false,
    searchable: true,
    sortable: false,
    store: false,
    string: MessageDeliveryerror,
    states: {

    }
  },
  message_has_error_counter: {
    type: integer,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    group_operator: sum,
    help: Numberofmessageswithdeliveryerror,
    manual: false,
    readonly: true,
    required: false,
    searchable: false,
    sortable: false,
    store: false,
    string: Numberoferrors,
    states: {

    }
  },
  message_attachment_count: {
    type: integer,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    group_operator: sum,
    groups: base.group_user,
    manual: false,
    readonly: true,
    required: false,
    searchable: false,
    sortable: false,
    store: false,
    string: AttachmentCount,
    states: {

    }
  },
  message_main_attachment_id: {
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
    readonly: true,
    relation: ir.attachment,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: MainAttachment,
    states: {

    }
  },
  failed_message_ids: {
    type: one2many,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [
      [
        model,
        =,
        project.project
      ],
      [
        mail_tracking_needs_action,
        =,
        true
      ],
      [
        mail_tracking_ids.state,
        in,
        [
          bounced,
          error,
          soft-bounced,
          spam,
          rejected
        ]
      ]
    ],
    manual: false,
    readonly: true,
    relation: mail.message,
    relation_field: res_id,
    required: false,
    searchable: true,
    sortable: false,
    store: true,
    string: FailedMessages,
    states: {

    }
  },
  website_message_ids: {
    type: one2many,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [
      [
        model,
        =,
        project.project
      ],
      |,
      [
        message_type,
        =,
        comment
      ],
      [
        message_type,
        =,
        email
      ]
    ],
    help: Websitecommunicationhistory,
    manual: false,
    readonly: true,
    relation: mail.message,
    relation_field: res_id,
    required: false,
    searchable: true,
    sortable: false,
    store: true,
    string: WebsiteMessages,
    states: {

    }
  },
  message_has_sms_error: {
    type: boolean,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    help: Ifchecked,
    somemessageshaveadeliveryerror.,
    manual: false,
    readonly: true,
    required: false,
    searchable: true,
    sortable: false,
    store: false,
    string: SMSDeliveryerror,
    states: {

    }
  },
  rating_ids: {
    type: one2many,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [
      [
        parent_res_model,
        =,
        project.project
      ]
    ],
    manual: false,
    readonly: true,
    relation: rating.rating,
    relation_field: parent_res_id,
    required: false,
    searchable: true,
    sortable: false,
    store: true,
    string: Ratings,
    states: {

    }
  },
  rating_percentage_satisfaction: {
    type: integer,
    change_default: false,
    company_dependent: false,
    depends: [
      rating_ids.rating,
      rating_ids.consumed
    ],
    group_operator: sum,
    help: Percentageofhappyratings,
    manual: false,
    readonly: true,
    required: false,
    searchable: false,
    sortable: false,
    store: false,
    string: RatingSatisfaction,
    states: {

    }
  },
  access_url: {
    type: char,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    help: CustomerPortalURL,
    manual: false,
    readonly: true,
    required: false,
    searchable: false,
    sortable: false,
    store: false,
    string: PortalAccessURL,
    translate: false,
    trim: true,
    states: {

    }
  },
  access_token: {
    type: char,
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
    string: SecurityToken,
    translate: false,
    trim: true,
    states: {

    }
  },
  access_warning: {
    type: text,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    manual: false,
    readonly: true,
    required: false,
    searchable: false,
    sortable: false,
    store: false,
    string: Accesswarning,
    translate: false,
    states: {

    }
  },
  assigned_attachment_ids: {
    type: one2many,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [
      [
        res_model,
        =,
        project.project
      ]
    ],
    manual: false,
    readonly: true,
    relation: ir.attachment,
    relation_field: res_id,
    required: false,
    searchable: true,
    sortable: false,
    store: true,
    string: AssignedAttachments,
    states: {

    }
  },
  id: {
    type: integer,
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
    string: ID,
    states: {

    }
  },
  display_name: {
    type: char,
    change_default: false,
    company_dependent: false,
    depends: [
      name
    ],
    manual: false,
    readonly: true,
    required: false,
    searchable: false,
    sortable: false,
    store: false,
    string: DisplayName,
    translate: false,
    trim: true,
    states: {

    }
  },
  create_uid: {
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
    readonly: true,
    relation: res.users,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: Createdby,
    states: {

    }
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
    string: Createdon,
    states: {

    }
  },
  write_uid: {
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
    readonly: true,
    relation: res.users,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: LastUpdatedby,
    states: {

    }
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
    string: LastUpdatedon,
    states: {

    }
  },
  __last_update: {
    type: datetime,
    change_default: false,
    company_dependent: false,
    depends: [
      create_date,
      write_date
    ],
    manual: false,
    readonly: true,
    required: false,
    searchable: false,
    sortable: false,
    store: false,
    string: LastModifiedon,
    states: {

    }
  },
  alias_name: {
    type: char,
    change_default: false,
    company_dependent: false,
    depends: [
      alias_id.alias_name
    ],
    help: Thenameoftheemailalias,
    e.g.'jobs'ifyouwanttocatchemailsfor<jobs@example.odoo.com>,
    manual: false,
    readonly: true,
    related: [
      alias_id,
      alias_name
    ],
    required: false,
    searchable: true,
    sortable: true,
    store: false,
    string: AliasName,
    translate: false,
    trim: true,
    states: {

    }
  },
  alias_model_id: {
    type: many2one,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [
      alias_id.alias_model_id
    ],
    domain: [
      ('field_id.name',
      '=',
      'message_ids')
    ],
    help: Themodel(OdooDocumentKind)towhichthisaliascorresponds.Anyincomingemailthatdoesnotreplytoanexistingrecordwillcausethecreationofanewrecordofthismodel(e.g.aProjectTask),
    manual: false,
    readonly: true,
    related: [
      alias_id,
      alias_model_id
    ],
    relation: ir.model,
    required: true,
    searchable: true,
    sortable: true,
    store: false,
    string: AliasedModel,
    states: {

    }
  },
  alias_user_id: {
    type: many2one,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [
      alias_id.alias_user_id
    ],
    domain: [

    ],
    help: Theownerofrecordscreateduponreceivingemailsonthisalias.Ifthisfieldisnotsetthesystemwillattempttofindtherightownerbasedonthesender(From)address,
    orwillusetheAdministratoraccountifnosystemuserisfoundforthataddress.,
    manual: false,
    readonly: true,
    related: [
      alias_id,
      alias_user_id
    ],
    relation: res.users,
    required: false,
    searchable: true,
    sortable: true,
    store: false,
    string: Owner,
    states: {

    }
  },
  alias_defaults: {
    type: text,
    change_default: false,
    company_dependent: false,
    depends: [
      alias_id.alias_defaults
    ],
    help: APythondictionarythatwillbeevaluatedtoprovidedefaultvalueswhencreatingnewrecordsforthisalias.,
    manual: false,
    readonly: true,
    related: [
      alias_id,
      alias_defaults
    ],
    required: true,
    searchable: true,
    sortable: true,
    store: false,
    string: DefaultValues,
    translate: false,
    states: {

    }
  },
  alias_force_thread_id: {
    type: integer,
    change_default: false,
    company_dependent: false,
    depends: [
      alias_id.alias_force_thread_id
    ],
    group_operator: sum,
    help: OptionalIDofathread(record)towhichallincomingmessageswillbeattached,
    eveniftheydidnotreplytoit.Ifset,
    thiswilldisablethecreationofnewrecordscompletely.,
    manual: false,
    readonly: true,
    related: [
      alias_id,
      alias_force_thread_id
    ],
    required: false,
    searchable: true,
    sortable: true,
    store: false,
    string: RecordThreadID,
    states: {

    }
  },
  alias_domain: {
    type: char,
    change_default: false,
    company_dependent: false,
    depends: [
      alias_id.alias_domain
    ],
    manual: false,
    readonly: true,
    related: [
      alias_id,
      alias_domain
    ],
    required: false,
    searchable: false,
    sortable: false,
    store: false,
    string: Aliasdomain,
    translate: false,
    trim: true,
    states: {

    }
  },
  alias_parent_model_id: {
    type: many2one,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [
      alias_id.alias_parent_model_id
    ],
    domain: [

    ],
    help: Parentmodelholdingthealias.Themodelholdingthealiasreferenceisnotnecessarilythemodelgivenbyalias_model_id(example: project(parent_model)andtask(model)),
    manual: false,
    readonly: true,
    related: [
      alias_id,
      alias_parent_model_id
    ],
    relation: ir.model,
    required: false,
    searchable: true,
    sortable: true,
    store: false,
    string: ParentModel,
    states: {

    }
  },
  alias_parent_thread_id: {
    type: integer,
    change_default: false,
    company_dependent: false,
    depends: [
      alias_id.alias_parent_thread_id
    ],
    group_operator: sum,
    help: IDoftheparentrecordholdingthealias(example: projectholdingthetaskcreationalias),
    manual: false,
    readonly: true,
    related: [
      alias_id,
      alias_parent_thread_id
    ],
    required: false,
    searchable: true,
    sortable: true,
    store: false,
    string: ParentRecordThreadID,
    states: {

    }
  },
  alias_contact: {
    type: selection,
    change_default: false,
    company_dependent: false,
    depends: [
      alias_id.alias_contact
    ],
    help: Policytopostamessageonthedocumentusingthemailgateway.-everyone: everyonecanpost-partners: onlyauthenticatedpartners-followers: onlyfollowersoftherelateddocumentormembersoffollowingchannels,
    manual: false,
    readonly: true,
    related: [
      alias_id,
      alias_contact
    ],
    required: true,
    searchable: true,
    selection: [
      [
        everyone,
        Everyone
      ],
      [
        partners,
        AuthenticatedPartners
      ],
      [
        followers,
        Followersonly
      ],
      [
        employees,
        AuthenticatedEmployees
      ]
    ],
    sortable: true,
    store: false,
    string: AliasContactSecurity,
    states: {

    }
  }
}
```
