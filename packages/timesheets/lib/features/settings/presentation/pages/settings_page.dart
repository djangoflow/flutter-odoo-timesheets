import 'package:flutter/cupertino.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/features/settings/presentation/section_title.dart';
import 'package:timesheets/features/settings/presentation/settings_list_item.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: const AutoLeadingButton(),
          title: const Text('Settings'),
          actions: [
            IconButton(
              onPressed: () {
                AuthCubit.instance.logout();
              },
              icon: const Icon(
                CupertinoIcons.chevron_left,
              ),
              tooltip: 'Logout',
            )
          ],
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) => SafeArea(
            bottom: true,
            child: Center(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kPadding * 2,
                        vertical: kPadding * 2,
                      ),
                      children: [
                        const SectionTitle(title: 'Theme'),
                        SettingsListItem(
                          title: 'Dark theme',
                          trailing: BlocBuilder<AppCubit, AppState>(
                            builder: (context, state) => CupertinoSwitch(
                              value: state.themeMode == ThemeMode.dark,
                              onChanged: (value) {
                                final isDarkTheme =
                                    state.themeMode == ThemeMode.dark;
                                AppCubit.instance.updateThemeMode(isDarkTheme
                                    ? ThemeMode.light
                                    : ThemeMode.dark);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: kPadding,
                        ),
                        const SectionTitle(title: 'Synchronizations'),
                        SettingsListItem(
                          title: '${state.user == null ? 'Add ' : ''}Odoo',
                          subTitle: state.user?.email,
                          trailing: Icon(
                            state.user != null
                                ? CupertinoIcons.chevron_back
                                : CupertinoIcons.chevron_forward,
                          ),
                          onTap: () => state.user != null
                              ? AuthCubit.instance.logout()
                              : context.router.push(
                                  const LoginRouter(),
                                ),
                        ),
                        const SizedBox(
                          height: kPadding,
                        ),

                        // const SectionTitle(title: 'Account'),
                        // LinearProgressBuilder(
                        //   action: (_) async =>
                        //       await AuthCubit.instance.logout(),
                        //   builder: (context, action, error) => ListItem(
                        //     title: 'Sign Out',
                        //     onTap: () => action,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: kPadding,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
