import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/configurations/configurations.dart';
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

  final Project? project;

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
            value: project?.color.toOdooColorFromColorIndex ?? OdooColors.white,
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
              padding: EdgeInsets.symmetric(
                horizontal: kPadding.h * 2,
                vertical: kPadding.w * 2,
              ),
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: kPadding.h * 2,
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
                SizedBox(
                  height: kPadding.h * 2,
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
                SizedBox(
                  height: kPadding.h * 2,
                ),
                Row(
                  children: [
                    ReactiveCheckbox(
                      formControlName: isFavoriteControlName,
                    ),
                    SizedBox(
                      width: kPadding.w,
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
            width: 24.r,
            height: 24.r,
            decoration: BoxDecoration(
              color: odooColor.color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(
            width: kPadding.w,
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
