import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PinWarning extends StatelessWidget {
  PinWarning({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.redAccent[100],
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.pinWarning,
          //style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
