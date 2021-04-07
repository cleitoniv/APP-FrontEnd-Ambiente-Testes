import 'package:flutter/material.dart';

class DropdownWidget extends StatefulWidget {
  List<dynamic> items;
  dynamic currentValue;
  Function onChanged;
  Widget prefixIcon;
  Widget suffixIcon;
  String labelText;

  DropdownWidget({
    @required this.items,
    @required this.currentValue,
    @required this.onChanged,
    this.labelText = 'Horário de Visita',
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(0),
        labelText: widget.labelText,
        labelStyle: Theme.of(context).textTheme.subtitle1.copyWith(
              color: Theme.of(context).primaryColor,
            ),
        alignLabelWithHint: true,
        prefixIcon: widget.prefixIcon != null
            ? widget.prefixIcon
            : Icon(
                Icons.remove_red_eye,
                color: Color(0xffA1A1A1),
              ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: widget.currentValue,
          items: widget.items.map(
            (e) {
              return DropdownMenuItem(
                child: FittedBox(fit: BoxFit.contain, child: Text('$e')),
                value: e,
              );
            },
          ).toList(),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
