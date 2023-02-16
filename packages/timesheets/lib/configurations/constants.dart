// Global APP - specific constants
const kAppLogoSvgPath = 'assets/app_logo/logo.svg';
const kAppTitle = 'Odoo Timesheets';
const kBaseUrl = 'https://portal.apexive.com/';

///This endpoint provides meta-calls which don’t require authentication.
const kCommonEndpoint = 'xmlrpc/2/common';

///It is used to call methods of odoo models. Require authentication.
const kObjectEndpoint = 'xmlrpc/2/object';

const db = 'wwnet-odoo';
const rpcFunction = 'execute_kw';

const projectMethod = 'project.project';
const taskMethod = 'project.task';
const usersMethod = 'res.users';
