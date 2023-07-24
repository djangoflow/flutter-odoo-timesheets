Available fields for Timesheet model on Odoo

```json
{
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
    string: Description,
    translate: false,
    trim: true
  },
  date: {
    type: date,
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
    string: Date
  },
  amount: {
    type: monetary,
    change_default: false,
    company_dependent: false,
    currency_field: currency_id,
    depends: [

    ],
    group_operator: sum,
    manual: false,
    readonly: false,
    required: true,
    searchable: true,
    sortable: true,
    store: true,
    string: Amount
  },
  unit_amount: {
    type: float,
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
    string: Quantity
  },
  product_uom_id: {
    type: many2one,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [
      ('category_id',
      '=',
      product_uom_category_id)
    ],
    manual: false,
    readonly: false,
    relation: uom.uom,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: UnitofMeasure
  },
  product_uom_category_id: {
    type: many2one,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [
      product_uom_id.category_id
    ],
    domain: [

    ],
    help: ConversionbetweenUnitsofMeasurecanonlyoccuriftheybelongtothesamecategory.Theconversionwillbemadebasedontheratios.,
    manual: false,
    readonly: true,
    related: [
      product_uom_id,
      category_id
    ],
    relation: uom.category,
    required: false,
    searchable: true,
    sortable: false,
    store: false,
    string: Category
  },
  account_id: {
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
    relation: account.analytic.account,
    required: true,
    searchable: true,
    sortable: true,
    store: true,
    string: AnalyticAccount
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
    string: Partner
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
    string: User
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
    relation: account.analytic.tag,
    required: false,
    searchable: true,
    sortable: false,
    store: true,
    string: Tags
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
    string: Company
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
    sortable: true,
    store: true,
    string: Currency
  },
  group_id: {
    type: many2one,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [
      account_id.group_id
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
    related: [
      account_id,
      group_id
    ],
    relation: account.analytic.group,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: Group
  },
  product_id: {
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
    relation: product.product,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: Product
  },
  general_account_id: {
    type: many2one,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [
      move_id.account_id
    ],
    domain: [
      [
        deprecated,
        =,
        false
      ]
    ],
    manual: false,
    readonly: true,
    related: [
      move_id,
      account_id
    ],
    relation: account.account,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: FinancialAccount
  },
  move_id: {
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
    relation: account.move.line,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: JournalItem
  },
  code: {
    type: char,
    change_default: false,
    company_dependent: false,
    depends: [

    ],
    manual: false,
    readonly: false,
    required: false,
    searchable: true,
    size: 8,
    sortable: true,
    store: true,
    string: Code,
    translate: false,
    trim: true
  },
  ref: {
    type: char,
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
    string: Ref.,
    translate: false,
    trim: true
  },
  task_id: {
    type: many2one,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [
      ('company_id',
      '=',
      company_id)
    ],
    manual: false,
    readonly: false,
    relation: project.task,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: Task
  },
  project_id: {
    type: many2one,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [
      [
        allow_timesheets,
        =,
        true
      ]
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
  employee_id: {
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
    relation: hr.employee,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: Employee
  },
  department_id: {
    type: many2one,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [
      employee_id
    ],
    domain: [

    ],
    manual: false,
    readonly: true,
    relation: hr.department,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: Department
  },
  encoding_uom_id: {
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
    relation: uom.uom,
    required: false,
    searchable: false,
    sortable: false,
    store: false,
    string: EncodingUom
  },
  sheet_id: {
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
    relation: hr_timesheet.sheet,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: Sheet
  },
  sheet_state: {
    type: selection,
    change_default: false,
    company_dependent: false,
    depends: [
      sheet_id.state
    ],
    manual: false,
    readonly: true,
    related: [
      sheet_id,
      state
    ],
    required: false,
    searchable: true,
    selection: [
      [
        new,
        New
      ],
      [
        draft,
        Open
      ],
      [
        confirm,
        WaitingReview
      ],
      [
        done,
        Approved
      ]
    ],
    sortable: false,
    store: false,
    string: SheetState
  },
  is_task_required: {
    type: boolean,
    change_default: false,
    company_dependent: false,
    depends: [
      project_id.is_timesheet_task_required
    ],
    manual: false,
    readonly: true,
    related: [
      project_id,
      is_timesheet_task_required
    ],
    required: false,
    searchable: true,
    sortable: false,
    store: false,
    string: IsTaskRequired
  },
  is_task_closed: {
    type: boolean,
    change_default: false,
    company_dependent: false,
    depends: [
      task_id.stage_id.closed
    ],
    help: Tasksinthisstageareconsideredclosed.,
    manual: false,
    readonly: true,
    related: [
      task_id,
      stage_id,
      closed
    ],
    required: false,
    searchable: true,
    sortable: false,
    store: false,
    string: Closed
  },
  holiday_id: {
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
    relation: hr.leave,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: LeaveRequest
  },
  so_line: {
    type: many2one,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [
      |,
      [
        qty_delivered_method,
        =,
        analytic
      ],
      [
        qty_delivered_method,
        =,
        timesheet
      ]
    ],
    manual: false,
    readonly: false,
    relation: sale.order.line,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: SalesOrderItem
  },
  date_time: {
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
    string: StartTime
  },
  date_time_end: {
    type: datetime,
    change_default: false,
    company_dependent: false,
    depends: [
      date_time,
      unit_amount,
      product_uom_id
    ],
    manual: false,
    readonly: false,
    required: false,
    searchable: false,
    sortable: false,
    store: false,
    string: EndTime
  },
  show_time_control: {
    type: selection,
    change_default: false,
    company_dependent: false,
    depends: [
      employee_id,
      unit_amount
    ],
    help: Indicatewhichtimecontrolbuttontoshow,
    ifany.,
    manual: false,
    readonly: true,
    required: false,
    searchable: false,
    selection: [
      [
        resume,
        Resume
      ],
      [
        stop,
        Stop
      ]
    ],
    sortable: false,
    store: false,
    string: ShowTimeControl
  },
  timesheet_invoice_type: {
    type: selection,
    change_default: false,
    company_dependent: false,
    depends: [
      so_line.product_id,
      project_id,
      task_id
    ],
    manual: false,
    readonly: true,
    required: false,
    searchable: true,
    selection: [
      [
        billable_time,
        BilledonTimesheets
      ],
      [
        billable_fixed,
        BilledataFixedprice
      ],
      [
        non_billable,
        NonBillableTasks
      ],
      [
        non_billable_project,
        Notaskfound
      ]
    ],
    sortable: true,
    store: true,
    string: BillableType
  },
  timesheet_invoice_id: {
    type: many2one,
    change_default: false,
    company_dependent: false,
    context: {

    },
    depends: [

    ],
    domain: [

    ],
    help: Invoicecreatedfromthetimesheet,
    manual: false,
    readonly: true,
    relation: account.move,
    required: false,
    searchable: true,
    sortable: true,
    store: true,
    string: Invoice
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
        account.analytic.line
      ]
    ],
    manual: false,
    readonly: false,
    relation: ir.attachment,
    relation_field: res_id,
    required: false,
    searchable: true,
    sortable: false,
    store: true,
    string: AssignedAttachments
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
    string: ID
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
    trim: true
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
    string: Createdby
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
    string: Createdon
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
    string: LastUpdatedby
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
    string: LastUpdatedon
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
    string: LastModifiedon
  }
}
```
