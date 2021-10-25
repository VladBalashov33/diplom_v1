import 'package:diplom/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultTextForm extends StatelessWidget {
  final String? hintText;
  final String? initialValue;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  final void Function(String)? onChanged;
  final bool isAutoFocus;
  final List<TextInputFormatter>? isInputFormatter;

  final Widget? suffixIcon;

  final TextEditingController? controller;

  const DefaultTextForm({
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.obscureText = false,
    this.onChanged,
    this.isAutoFocus = false,
    this.validator,
    this.isInputFormatter,
    this.controller,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(15);
    final outlineInputBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: const BorderSide(
        color: Colors.transparent,
        width: 2,
      ),
    );
    final outlineInputBorderRed = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: const BorderSide(
        color: AppColors.redC61E15,
        width: 2,
      ),
    );
    return TextFormField(
      initialValue: initialValue,
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.disabled,
      expands: false,
      autofocus: isAutoFocus,
      inputFormatters: isInputFormatter ?? [],
      controller: controller,
      textAlignVertical: TextAlignVertical.center,
      style: AppTypography.font16.copyWith(
        color: Colors.white,
        height: 1.0,
      ),
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        focusedBorder: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        errorBorder: outlineInputBorderRed,
        focusedErrorBorder: outlineInputBorderRed,
        disabledBorder: outlineInputBorder,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        isDense: true,
        errorMaxLines: 1,
        hintText: hintText,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: suffixIcon,
        ),
      ),
      onChanged: onChanged,
    );
  }
}

class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newTextBuffer = StringBuffer();
    var selectionIndex = newValue.selection.end;

    if (newValue.text == '+7 (') {
      return TextEditingValue(
        text: newTextBuffer.toString(),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
    if (newValue.text.length == 19) {
      {
        return TextEditingValue(
          text: oldValue.text,
          selection: TextSelection.collapsed(offset: oldValue.selection.end),
        );
      }
    }

    final newString = newValue.text
        .replaceAll(RegExp(r'\D'), '')
        .replaceFirst('7', '')
        .split('');
    final newText = <String>[
      '+',
      '7',
      ' ',
      '(',
      ' ',
      ' ',
      ' ',
      ')',
      ' ',
      ' ',
      ' ',
      ' ',
      '-',
      ' ',
      ' ',
      '-',
      ' ',
      ' ',
    ];
    var newStringEnd = 0;
    for (var i = 0; i < newString.length; i++) {
      final n = getNumberSelection(i);
      newText[n] = newString[i];
      newStringEnd = i;
    }
    newStringEnd = getNumberSelection(newStringEnd + 1);

    selectionIndex = getNumberTransfer(
      newValue.selection.end,
      isBack: oldValue.selection.end >= newValue.selection.end,
    );
    if (selectionIndex > getNumberSelection(newString.length)) {
      if (getNumberSelection(newString.length) != 0) {
        selectionIndex = getNumberSelection(newString.length);
      }
    }

    newTextBuffer.write(newText
        .toString()
        .replaceAll(', ', '')
        .replaceAll('[', '')
        .replaceAll(']', '')
        .substring(0, newStringEnd));
    return TextEditingValue(
      text: newTextBuffer.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }

  int getNumberSelection(int i) {
    var n = 0;
    switch (i) {
      case 0:
        n = 4;
        break;
      case 1:
        n = 5;
        break;
      case 2:
        n = 6;
        break;
      case 3:
        n = 9;
        break;
      case 4:
        n = 10;
        break;
      case 5:
        n = 11;
        break;
      case 6:
        n = 13;
        break;
      case 7:
        n = 14;
        break;
      case 8:
        n = 16;
        break;
      case 9:
        n = 17;
        break;
      case 10:
        n = 18;
        break;
      default:
    }
    return n;
  }

  int getNumberTransfer(int i, {required bool isBack}) {
    var n = 0;
    switch (i) {
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
        n = 5;
        break;
      case 6:
        n = 6;
        break;
      case 7:
        isBack ? n = 7 : n = 9;
        break;
      case 8:
        isBack ? n = 7 : n = 10;
        break;
      case 9:
        n = 7;
        break;
      case 10:
        n = 10;
        break;
      case 11:
        n = 11;
        break;
      case 12:
        isBack ? n = 12 : n = 13;
        // n = 13;
        break;
      case 13:
        isBack ? n = 12 : n = 14;
        break;
      case 14:
        n = 14;
        break;
      case 15:
        isBack ? n = 15 : n = 16;
        break;
      case 16:
        isBack ? n = 15 : n = 17;
        break;
      case 17:
        //isBack ? n = 15 :
        n = 17;
        break;
      case 18:
        n = 18;
        break;
      default:
        n = 18;

        break;
    }
    print('==$n==');
    return n;
  }
}
