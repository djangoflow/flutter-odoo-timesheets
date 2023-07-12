// Global APP - specific constants
const sentryDSN = '';
const appLogoSvgPath = 'assets/app_logo/logo.svg';
const appTitle = 'Apexive Timesheets';
const appFontFamily = 'Inter';
const designHeight = 852.0;
const designWidth = 393.0;

// animation constants
const animationDurationDefault = Duration(milliseconds: 300);
const animationDurationShort = Duration(milliseconds: 150);
const animationDurationLong = Duration(milliseconds: 500);

const apexiveUrl = 'https://apexive.com/';

// odoo related

///This endpoint provides meta-calls which don’t require authentication.
const commonEndpoint = 'xmlrpc/2/common';

///It is used to call methods of odoo models. Require authentication.
const objectEndpoint = 'xmlrpc/2/object';

///Used to get db list
const dbEndpoint = 'xmlrpc/db';

const rpcFunction = 'execute_kw';
const rpcAuthenticationFunction = 'authenticate';

const projectModel = 'project.project';
const taskModel = 'project.task';
const usersModel = 'res.users';
const timesheetModel = 'account.analytic.line';

//Odoo fields
const offset = 'offset';
const limit = 'limit';
const fields = 'fields';

// Odoo model fields
const name = 'name';

const caseInsensitiveComparison = 'ilike';

// form control names
const emailControlName = 'email';
const passControlName = 'pass';
const serverUrlControlName = 'serverUrl';
const dbControlName = 'db';
const projectControlName = 'selectedProject';
const taskControlName = 'selectedTask';
const descriptionControlName = 'description';

const searchDelayMs = 500;

// TODO need to change it to support multiple backend properly
const hardcodedBackendId = 1;
