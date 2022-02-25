import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:arduino_statemachines/resources/settings.dart';
import 'package:arduino_statemachines/resources/states_data.dart';

class InitDropdown extends StatefulWidget {
  final bool component;
  final dynamic value;
  final Function(dynamic newValue) valueOnChanged;
  final List<dynamic> options;

  InitDropdown({
    this.component = false,
    required this.value,
    required this.valueOnChanged,
    required this.options,
    Key? key,
  }) : super(key: key);

  @override
  State<InitDropdown> createState() => _InitDropdownState();
}

class _InitDropdownState extends State<InitDropdown> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButtonFormField(
        isExpanded: true,
        value: widget.value,
        style: const TextStyle(fontSize: 12),
        onChanged: (dynamic newValue) {
          widget.valueOnChanged(newValue);
        },
        validator: (dynamic value) {
          if (value == null) {
            return AppLocalizations.of(context)!.fieldRequired;
          }
          return null;
        },
        items: widget.options.map<DropdownMenuItem>((dynamic value) {
          return DropdownMenuItem(
            value: value,
            child: Center(
              child: widget.component
                  ? ComponentDropdown(value: value)
                  : Text(
                      value.toString(),
                      textAlign: TextAlign.center,
                    ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ComponentDropdown extends StatelessWidget {
  final String value;

  ComponentDropdown({
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 25.0,
          height: 25.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: getBlockColorByType(returnDataByName(value).type),
            image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage(returnDataByName(value).imagePath),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(AppLocalizations.of(context)!.json(value)),
      ],
    );
  }
}
