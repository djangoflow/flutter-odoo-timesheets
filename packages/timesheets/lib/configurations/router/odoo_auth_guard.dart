// import 'package:timesheets/features/authentication/authentication.dart';
// import 'package:timesheets/features/external/external.dart';
// import 'package:timesheets/utils/utils.dart';

// import 'router.dart';

// class OdooAuthGuard extends AutoRouteGuard {
//   final AuthCubit authCubit;

//   OdooAuthGuard(this.authCubit);

//   @override
//   void onNavigation(NavigationResolver resolver, StackRouter router) {
//     // the navigation is paused until resolver.next() is called with either
//     // true to resume/continue navigation or false to abort navigation
//     if (authCubit.state.connectedBackends
//         .getBackendsFilteredByType(BackendTypeEnum.odoo)
//         .isNotEmpty) {
//       // if user is authenticated we continue
//       resolver.next(true);
//     } else {
//       // we redirect the user to our login page
//       // tip: use resolver.redirect to have the redirected route
//       // automatically removed from the stack when the resolver is completed
//       resolver.redirect(
//         OdooLoginRoute(
//           onLoginSuccess: (success) {
//             // if success == true the navigation will be resumed
//             // else it will be aborted
//             resolver.next(success);
//           },
//         ),
//         onFailure: (failure) => resolver.next(false),
//       );
//     }
//   }
// }
