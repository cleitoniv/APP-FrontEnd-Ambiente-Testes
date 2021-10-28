import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatefulWidget {
  final String labelText;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final TextCapitalization textCapitalization;
  final TextEditingController controller;
  final Function validator;
  final double width;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool enabled;
  final bool readOnly;
  final Function onTap;
  final String initialValue;
  final String hint;
  final FocusNode focus;
  final TextInputFormatter inputFormatters;
  final int maxLength;
  final bool maxLengthEnforce;
  final bool inputFormattersActivated;

  TextFieldWidget({
    this.textCapitalization,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.width = double.infinity,
    this.obscureText = false,
    this.keyboardType,
    this.enabled = true,
    this.initialValue,
    this.readOnly = false,
    this.onTap,
    this.focus,
    this.maxLength,
    this.maxLengthEnforce = false,
    this.hint = '',
    this.inputFormatters,
    this.inputFormattersActivated = false,
  });

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: TextFormField(
        maxLength: widget.maxLength,
        maxLengthEnforced: widget.maxLengthEnforce ?? false,
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.none,
        initialValue: widget.initialValue,
        enabled: widget.enabled,
        controller: widget.controller,
        validator: widget.validator,
        focusNode: widget.focus ?? _focusNode,
        onTap: widget.onTap,
        readOnly: widget.readOnly,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        inputFormatters: [
          widget.inputFormattersActivated
              ? FilteringTextInputFormatter.allow(RegExp("[0-9]"))
              : FilteringTextInputFormatter.allow(RegExp(".*"))
        ],
        decoration: InputDecoration(
          errorMaxLines: 4,
          hintText: widget.hint,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.black38,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.black38,
            ),
          ),
          labelText: widget.labelText,
          labelStyle: Theme.of(context).textTheme.subtitle2.copyWith(
                color: _focusNode.hasFocus
                    ? Theme.of(context).primaryColor
                    : Colors.black38,
              ),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
        ),
        style: Theme.of(context).textTheme.subtitle1.copyWith(
              color: widget.enabled ? null : Colors.black38,
            ),
      ),
    );
  }
}
