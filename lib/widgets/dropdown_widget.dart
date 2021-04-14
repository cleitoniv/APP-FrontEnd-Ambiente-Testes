import 'package:flutter/material.dart';

class DropdownWidget extends StatefulWidget {
  final List<dynamic> items;
  final dynamic currentValue;
  final Function onChanged;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final String labelText;
  final Widget hint;

  DropdownWidget(
      {@required this.items,
      @required this.currentValue,
      @required this.onChanged,
      this.labelText = 'Período para Atendimento',
      this.prefixIcon,
      this.suffixIcon,
      this.hint});

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
          hint: widget.hint,
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
