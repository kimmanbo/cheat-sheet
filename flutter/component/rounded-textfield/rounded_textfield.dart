import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RoundedTextField extends StatelessWidget {
  @protected final FocusNode focusNode = new FocusNode();
  late final RoundedTextFieldController _c;
  late final double _width;
  late final double _height;
  late final double _fontSize;
  late final FontWeight _fontWeight;
  late final TextAlign _align;
  late final Color? _cursorColor;
  late final double _cursorWidth;
  late final Color _color;
  late final Color _warning;
  late final String? _hint;
  late final TextInputType _textInputType;
  late final bool _isPassword;
  late final List<TextInputFormatter>? _textInputFormatters;

  RoundedTextField(
    // positioned arguments
    this._c,
    this._width,
    this._height, {
    // named arguments
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color fontColor = Colors.black,
    TextAlign align = TextAlign.left,
    Color? cursorColor,
    double cursorWidth = 2.0,
    Color color = Colors.black,
    Color warning = Colors.redAccent,
    String? hint,
    TextInputType textInputType = TextInputType.text,
    bool isPassword = false,
    List<TextInputFormatter>? textInputFormatters,
  })  : _fontSize = fontSize,
        _fontWeight = fontWeight,
        _align = align,
        _cursorColor = cursorColor,
        _cursorWidth = cursorWidth,
        _color = color,
        _warning = warning,
        _hint = hint,
        _textInputType = textInputType,
        _isPassword = isPassword,
        _textInputFormatters = textInputFormatters;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          width: this._width,
          height: this._height,
          decoration: BoxDecoration(
              border:
                  Border.all(color: _c.isWarning ? _warning : _color, width: 3),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 30),
              ),
              Expanded(
                child: TextField(
                  focusNode: focusNode,
                  controller: _c,
                  keyboardType: _textInputType,
                  obscureText: _isPassword,
                  obscuringCharacter: "*",
                  textAlign: _align,
                  cursorColor: _cursorColor,
                  cursorWidth: _cursorWidth,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: _hint,
                    hintStyle: TextStyle(color: Colors.black12),
                  ),
                  style: TextStyle(
                    fontSize: _fontSize,
                    fontWeight: _fontWeight,
                    color: _c.isWarning ? _warning : _color,
                  ),
                  inputFormatters: _textInputFormatters,
                  onChanged: (text) {
                    if (_c.isWarning) {
                      _c.setWarning(false);
                    }
                  },
                ),
              ),
              Padding(padding: EdgeInsets.only(right: 10)),
            ],
          ),
        ));
  }
}

class RoundedTextFieldController extends TextEditingController {
  var _isWarning = false.obs;

  bool get isWarning => _isWarning.value;

  void setWarning(bool value) {
    _isWarning.value = value;
  }

  bool validate() {
    // At least 8 characters, 1 letter, 1 numeric
    String pattern = r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$";
    RegExp regExp = new RegExp(pattern);

    return regExp.hasMatch(this.value.text);
  }
}
