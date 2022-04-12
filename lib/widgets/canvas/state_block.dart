import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StateBlock extends StatelessWidget {
  final String name;
  final Color color;
  final String imagePath;
  final String option;
  final int? pin;
  final String selectedOption;
  final Function(String name) updateName;
  final TextEditingController controller;

  StateBlock(this.name, this.color, this.imagePath, this.option, this.pin,
      this.selectedOption, this.updateName, this.controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).scaffoldBackgroundColor,
        image: DecorationImage(
          image: AssetImage(imagePath),
          scale: 2,
        ),
      ),
      child: Card(
        margin: EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: color,
            width: 2,
          ),
        ),
        color: Color.fromRGBO(255, 255, 255, .7),
        shadowColor: color,
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextFormField(
                controller: controller
                  ..value = TextEditingValue(
                      text: name,
                      selection: TextSelection(
                          baseOffset: name.length, extentOffset: name.length)),
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                  isDense: true,
                ),
                onChanged: (text) {
                  updateName(text);
                },
              ),
              Column(
                children: [
                  Container(
                    height: 20,
                    child: Text(
                      AppLocalizations.of(context)!.json(option),
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                      height: 20,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          AppLocalizations.of(context)!.pin +
                              ": " +
                              (pin == null
                                  ? AppLocalizations.of(context)!.unassigned
                                  : pin.toString()),
                          style: TextStyle(
                            fontSize: 11.0,
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
