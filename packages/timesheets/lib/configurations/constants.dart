// Global APP - specific constants
import 'package:responsive_framework/responsive_framework.dart';

const sentryDSN =
    'https://9f79159affdc4f24b3751be3ef61617d@alerts.djangoflow.net/37';
const appLogoSvgPath = 'assets/app_logo/logo.svg';
const appTitle = 'Apexive Timesheets';
const appFontFamily = 'Inter';
const designHeight = 852.0;
const designWidth = 375.0;

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
const offsetKey = 'offset';
const limitKey = 'limit';
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
const isFavoriteControlName = 'isFavorite';
const colorControlName = 'color';
const searchDelayMs = 500;
// Responsive Breakpoints
const minBreakpoint = 0.0;
const mobileBreakpoint = 450.0;
const tabletBreakpoint = 800.0;
const desktopBreakpoint = 1920.0;
const ultraHdBreakpoint = double.infinity;
const maxScreenWidth = 600.0;
const List<Breakpoint> defaultBreakpoints = [
  Breakpoint(
    start: minBreakpoint,
    end: mobileBreakpoint,
    name: MOBILE,
  ),
  Breakpoint(
    start: mobileBreakpoint + 1,
    end: tabletBreakpoint,
    name: TABLET,
  ),
  Breakpoint(
    start: tabletBreakpoint + 1,
    end: desktopBreakpoint,
    name: DESKTOP,
  ),
  Breakpoint(
    start: desktopBreakpoint + 1,
    end: ultraHdBreakpoint,
    name: '4K',
  ),
];
