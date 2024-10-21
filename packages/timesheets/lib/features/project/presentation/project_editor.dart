import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/utils/utils.dart';

class ProjectEditor extends StatelessWidget {
  const ProjectEditor({
    super.key,
    required this.builder,
    this.project,
    this.additionalChildrenBuilder,
    this.isFavorite,
  });

  final ProjectModel? project;

  final List<Widget> Function(BuildContext context)? additionalChildrenBuilder;
  final bool? isFavorite;

  final Widget Function(
      BuildContext context, FormGroup form, Widget formListView) builder;

  FormGroup get _formGroup => fb.group(
        {
          projectControlName: FormControl<String>(
            value: project?.name,
            validators: [
              Validators.required,
            ],
          ),
          colorControlName: FormControl<OdooColors>(
            value:
                project?.color.toOdooColorFromColorIndex ?? OdooColors.noColor,
          ),
          isFavoriteControlName: FormControl<bool>(
            value: isFavorite ?? false,
          ),
        },
      );

  @override
  Widget build(BuildContext context) => ReactiveFormBuilder(
        form: () => _formGroup,
        builder: (context, formGroup, child) {
          final formListView = GestureDetector(
            onTap: () => formGroup.unfocus(),
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: kPadding * 2,
                vertical: kPadding * 2,
              ),
              shrinkWrap: true,
              children: [
                const SizedBox(
                  height: kPadding * 2,
                ),
                ReactiveTextField(
                  formControlName: projectControlName,
                  textCapitalization: TextCapitalization.none,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter Project Name',
                    labelText: 'Name',
                  ),
                  validationMessages: {
                    ValidationMessage.required: (_) => 'Name is required',
                  },
                ),
                const SizedBox(
                  height: kPadding * 2,
                ),
                ReactiveDropdownField<OdooColors>(
                  formControlName: colorControlName,
                  elevation: 0,
                  decoration: const InputDecoration(
                    hintText: 'Select Color',
                    labelText: 'Color',
                  ),
                  dropdownColor: Theme.of(context)
                      .colorScheme
                      .surfaceVariant
                      .withOpacity(.84),
                  icon: const Icon(
                    CupertinoIcons.chevron_down,
                  ),
                  selectedItemBuilder: (context) => OdooColors.values
                      .map(
                        (e) => _OdooColorLabel(
                          odooColor: e,
                          key: Key(e.name),
                        ),
                      )
                      .toList(),
                  items: OdooColors.values
                      .map(
                        (e) => DropdownMenuItem<OdooColors>(
                          value: e,
                          child: _OdooColorLabel(
                            odooColor: e,
                            key: Key(e.name),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(
                  height: kPadding * 2,
                ),
                Row(
                  children: [
                    ReactiveCheckbox(
                      formControlName: isFavoriteControlName,
                    ),
                    const SizedBox(
                      width: kPadding,
                    ),
                    Text(
                      'Make Favorite',
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  ],
                ),
                if (additionalChildrenBuilder != null)
                  ...additionalChildrenBuilder!(context),
              ],
            ),
          );

          return builder(context, formGroup, formListView);
        },
      );
}

class _OdooColorLabel extends StatelessWidget {
  const _OdooColorLabel({super.key, required this.odooColor});
  final OdooColors odooColor;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: odooColor.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(
            width: kPadding,
          ),
          Text(
            odooColor.colorLabel,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1,
                ),
          ),
        ],
      );
}
