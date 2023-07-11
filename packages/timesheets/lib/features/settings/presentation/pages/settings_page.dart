import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:url_launcher/url_launcher_string.dart';

import '../../setction_title.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final schemeColors = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: kPadding * 9,
        leading: const Row(
          children: [
            SizedBox(width: kPadding * 2),
            AutoLeadingButton(),
          ],
        ),
        title: const Text('Settings'),
      ),
      body: SafeArea(
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
                    ListTile(
                      title: const Text('Dark theme'),
                      trailing: BlocBuilder<AppCubit, AppState>(
                        builder: (context, state) => Switch(
                          trackColor: MaterialStateProperty.all(
                            schemeColors.onSurfaceVariant.withOpacity(0.2),
                          ),
                          thumbColor: MaterialStateProperty.all(
                            schemeColors.primary,
                          ),
                          thumbIcon: MaterialStateProperty.all(
                            Icon(
                              state.themeMode == ThemeMode.dark
                                  ? CupertinoIcons.moon_fill
                                  : CupertinoIcons.sun_min_fill,
                              color: schemeColors.onPrimary,
                            ),
                          ),
                          value: state.themeMode == ThemeMode.dark,
                          onChanged: (value) {
                            final isDarkTheme =
                                state.themeMode == ThemeMode.dark;
                            AppCubit.instance.updateThemeMode(
                                isDarkTheme ? ThemeMode.light : ThemeMode.dark);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: kPadding,
                    ),
                    const SectionTitle(title: 'Synchronizations'),
                    ListTile(
                      title: const Text('Add Odoo account'),
                      trailing: Icon(
                        Icons.chevron_right,
                        size: kPadding.w * 4,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(
                      height: kPadding,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: kPadding / 8,
                  margin: const EdgeInsets.all(kPadding * 2),
                  color: schemeColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kPadding),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(kPadding * 2),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Made with ♥ by ',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: schemeColors.onSurfaceVariant,
                          ),
                          children: [
                            TextSpan(
                              text: 'Apexive',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: schemeColors.onSurface,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => launchUrlString(
                                      apexiveUrl,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
