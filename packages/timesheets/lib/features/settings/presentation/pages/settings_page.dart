import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/presentation/icon_card.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/features/settings/presentation/section_title.dart';
import 'package:timesheets/features/settings/presentation/settings_list_item.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
        leading: Row(
          children: const [
            SizedBox(width: kPadding * 2),
            IconCard(
              child: AutoLeadingButton(),
            ),
          ],
        ),
        title: const Text('Settings'),
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
                          builder: (context, state) => Switch(
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
                        onTap: () => context.router.push(
                          const LoginRouter(),
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
      ),
    );
  }
}
