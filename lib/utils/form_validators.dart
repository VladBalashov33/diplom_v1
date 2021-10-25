class FormValidators {
  static const String _passwordRegex = r'[a-zA-Z0-9]';
  static const String _emailRegex =
      r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z]+';

  static String? Function(String?)? emailValidator() => (arg) {
        arg = arg?.trim() ?? '';
        if (arg.isEmpty) {
          return 'Поле не может быть пусты';
        } else {
          return RegExp(_emailRegex, caseSensitive: false).hasMatch(arg)
              ? null
              : 'Введите правильный email';
        }
      };

  static String? Function(String?)? oldPasswordValidator(String? oldPassword) =>
      (arg) {
        print(oldPassword);
        return oldPassword == arg ? null : 'Пароли не совпадают';
      };

  static String? Function(String?)? passwordValidator() => (arg) {
        arg = arg?.trim() ?? '';
        if (arg.isEmpty) {
          return 'Поле не может быть пустым';
        } else {
          if (arg.length < 6) {
            return 'Пароль слишком короткий';
          }
          return RegExp(_passwordRegex, caseSensitive: false).hasMatch(arg)
              ? null
              : 'Пароль содержит недопустимые символы';
        }
      };

  static String? Function(String?)? phoneValidator() => (arg) {
        arg = arg ?? '';
        if (arg.isEmpty) {
          return 'Поле не может быть пустым';
        } else {
          return (arg.length == 18) ? null : 'Неверный номер телефона';
        }
      };

  static String? Function(String?)? textValidator() => (arg) {
        arg = arg?.trim() ?? '';
        if (arg.trim().isEmpty) {
          return 'Поле не может быть пустым';
        } else {
          return null;
        }
      };
}
